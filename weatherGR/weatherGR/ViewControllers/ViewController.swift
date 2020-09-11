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

class ViewController: BasicViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,CLLocationManagerDelegate, GetLocationProtocolDelegate, MapPressedDelegate  {
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
    @IBOutlet weak var weatherImageView: UIImageView!
    
    var currentWeather: WeatherDetail2?
    var dailyWeather: [Daily]?
    var searchHistory: [NSManagedObject] = []
    var mapImage: UIImage?
    var mapVC: MapViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WeatherGR"
        searchBar.delegate = self
        if let geoLocation = LocationManager.shared.coordinates {
            checkWeather(lat: String(geoLocation.latitude), lon: String(geoLocation.longitude))
        } else {
            checkWeather(placeName: "Kosice")
        }
        searchBar.barTintColor = UIColor.clear
        mapVC = tabBarController?.viewControllers?[1] as? MapViewController
        mapVC?.mapPressedDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.backgroundColor = UIColor.clear
        self.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Enter city...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        self.searchBar.searchTextField.textColor = UIColor.white

    }

    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        } else if section == 2 && mapImage == nil {
            return 0
        } else if section == 2 && mapImage != nil{
            return 1
        } else {
            return dailyWeather?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "todayWeatherCell") as! TodayWeatherTableViewCell
            cell.placeLabel.text = currentWeather?.name ?? ""
            cell.temperatureLabel.text = String(format: "%.0f"+" ºC",currentWeather?.main?.temp ?? 0)
            cell.getLocationDelegate = self
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapViewCell") as! MapFrameTableViewCell
                if let image = mapImage {
                    cell.mapImageView.image = image
                    cell.isHidden = false
                    return cell
                } else {
                    mapVC?.rect = cell.mapImageView.bounds
                    cell.isHidden = true
                    return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "simpleWeatherCell") as! DailyWeatherTableViewCell
            cell.dayLabel.text = dailyWeather?[indexPath.row].dt?.getDateFromTimeStamp().dayOfWeek() ?? ""
            cell.rainProbabilityLabel.text = dailyWeather?[indexPath.row].pop?.getProbability()
            cell.forecastLabel.text = dailyWeather?[indexPath.row].weather?.first?.main ?? ""
            cell.dayTemperatureLabel.text = String(format: "%.0f"+" ºC",dailyWeather?[indexPath.row].temp?.day?.rounded() ?? 0)
            cell.nightTemperatureLabel.text = String(format: "%.0f"+" ºC",dailyWeather?[indexPath.row].temp?.night?.rounded() ?? 0)
            cell.forecastIconImageView.image = UIImage(named: getForecastIcon(forecast: dailyWeather?[indexPath.row].weather?.first?.main ?? ""))
            return cell
        }
    }
    
    //MARK: SearchBar
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        checkWeather(placeName: searchBar.text ?? "")
    }
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

