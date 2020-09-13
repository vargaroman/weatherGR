//
//  ViewController.swift
//  weatherGR
//
//  Created by Roman Varga on 09/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: BasicViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, GetLocationProtocolDelegate, MapPressedDelegate  {
    func passImageToTable(coordinates: CLLocationCoordinate2D, mapImage: UIImage) {
        self.mapImage = mapImage
        self.checkWeather(lat: String(coordinates.latitude), lon: String(coordinates.longitude))
    }
    
    func getMyLocation() {
        self.mapImage = nil
        LocationManager.shared.start()
        if let geo = LocationManager.shared.coordinates {
            checkWeather(lat: String(geo.latitude), lon: String(geo.longitude))
        }
        LocationManager.shared.stop()
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentWeather: WeatherDetail2?
    var dailyWeather: [Daily]?
    var searchHistory: [NSManagedObject] = []
    var mapImage: UIImage?
    var mapVC: MapViewController?
    var isInitialLoad: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WeatherGR"
        searchBar.delegate = self
        mapVC = tabBarController?.viewControllers?[1] as? MapViewController
        mapVC?.mapPressedDelegate = self
        let historyVC = tabBarController?.viewControllers?[2] as? HistoryViewController
        historyVC?.historyPressedDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.backgroundColor = UIColor.clear
        self.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Enter city...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.primaryColor])
        self.searchBar.searchTextField.backgroundColor = UIColor.lightNavyColor
        self.searchBar.searchTextField.textColor = UIColor.primaryColor
        
        if let geoLocation = LocationManager.shared.coordinates{
            if isInitialLoad{
                checkWeather(lat: String(geoLocation.latitude), lon: String(geoLocation.longitude))
                isInitialLoad = false
            }
            
        }
    }
    

    //MARK: TableView
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else{
            return dailyWeather?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "todayWeatherCell") as! TodayWeatherTableViewCell
            
            cell.placeLabel.text = currentWeather?.name ?? ""
            cell.temperatureLabel.text = String(format: "%.0f"+" ºC",currentWeather?.main?.temp ?? 0)
            cell.getLocationDelegate = self
            cell.bottomCornerRadius(radius: 15)
            cell.setBackgroundImage(weather: currentWeather?.weather?.first?.main ?? "")
            cell.windSpeedLabel.text = String(format: "%.0f"+" m/s",currentWeather?.wind?.speed ?? 0)
            cell.windDirectionLabel.text = currentWeather?.wind?.deg?.getWindDirection() ?? ""
            cell.sunSetLabel.text = currentWeather?.sys?.sunset?.getHourFromTimeStamp()
            cell.sunRiseLabel.text = currentWeather?.sys?.sunrise?.getHourFromTimeStamp()
            return cell
        } else if indexPath.row == 1 && mapImage != nil{
            let image = mapImage
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapViewCell") as! MapFrameTableViewCell
            mapVC?.rect = cell.mapImageView.bounds
            cell.mapImageView.image = image
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.layer.borderColor = UIColor.secondaryColor.cgColor
            cell.layer.borderWidth = 2
            cell.isHidden = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "simpleWeatherCell") as! DailyWeatherTableViewCell
            cell.dayLabel.text = dailyWeather?[indexPath.row].dt?.getDateFromTimeStamp().dayOfWeek() ?? ""
            cell.rainProbabilityLabel.text = dailyWeather?[indexPath.row].pop?.getProbability()
            cell.forecastLabel.text = dailyWeather?[indexPath.row].weather?.first?.main ?? ""
            cell.dayTemperatureLabel.text = String(format: "%.0f"+" ºC",dailyWeather?[indexPath.row].temp?.day?.rounded() ?? 0)
            cell.nightTemperatureLabel.text = String(format: "%.0f"+" ºC",dailyWeather?[indexPath.row].temp?.night?.rounded() ?? 0)
            cell.forecastIconImageView.image = UIImage(named: dailyWeather?[indexPath.row].weather?.first?.main?.getForecastIcon() ?? "")
            return cell
        }
    }
    //MARK: SearchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        checkWeather(placeName: searchBar.text ?? "")
        save(text: searchBar.text ?? "")
        self.dismissKeyboard()
        self.mapImage = nil
        self.searchBar.text = ""
    }
    
    //MARK: CoreDataHistory
    func save(text: String) {
        guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let managedContext =
        appDelegate.persistentContainer.viewContext
        let entity =
        NSEntityDescription.entity(forEntityName: "SearchHistory",
                                   in: managedContext)!
      
        let newRow = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        newRow.setValue(text, forKeyPath: "text")
        newRow.setValue(formatter.string(from: date), forKey: "date")
        do {
            try managedContext.save()
            searchHistory.append(newRow)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

