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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,CLLocationManagerDelegate  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    var currentWeather: WeatherDetail2?
    var dailyWeather: [Daily]?
    var searchHistory: [NSManagedObject] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WeatherGR"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "historyIcon"), style: .plain, target: self, action: #selector(historyButtonTapped))
        searchBar.delegate = self
        if let geoLocation = LocationManager.shared.coordinates {
            checkWeather(lat: String(geoLocation.latitude), lon: String(geoLocation.longitude))
        } else {
            checkWeather(placeName: "Kosice")
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func historyButtonTapped(){
        self.performSegue(withIdentifier: "goToHistory", sender: searchHistory)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHistory" {
            let vc = segue.destination as? HistoryViewController
            vc?.history = sender as! [NSManagedObject]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
        let managedContext =
        appDelegate.persistentContainer.viewContext
      
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "SearchHistory")
      
    do {
        searchHistory = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeather?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleWeatherCell") as! DailyWeatherTableViewCell
        cell.dayLabel.text = dailyWeather?[indexPath.row].dt?.getDateFromTimeStamp() ?? "0"
        cell.rainProbabilityLabel.text = dailyWeather?[indexPath.row].pop?.getProbability()
        cell.forecastLabel.text = dailyWeather?[indexPath.row].weather?.first?.main ?? ""
        cell.temperatureLabel.text = "\(dailyWeather?[indexPath.row].temp?.max?.rounded() ?? 0)"+" \\ " + "\(dailyWeather?[indexPath.row].temp?.min?.rounded() ?? 0)"

        return cell
    }
    
    func checkWeather(placeName: String) {
        NetworkManager().getActualWeather(placeName: placeName) { [weak self] (weather) in
            self?.currentWeather = weather
            DispatchQueue.main.async {
                self?.temperatureLabel.text = "\(weather.main?.temp?.rounded() ?? 0) ºC"
                self?.setBackgroundImage(weather: weather.weather?.first?.main ?? "")
                self?.placeLabel.text = weather.name ?? ""
                self?.checkWeatherForDays()
            }
        }
    }
    
    func checkWeather(lat: String, lon: String) {
        NetworkManager().getActualWeather(lat: lat, lon: lon) { [weak self] (weather) in
            self?.currentWeather = weather
            DispatchQueue.main.async {
                self?.temperatureLabel.text = "\(weather.main?.temp?.rounded() ?? 0) ºC"
                self?.setBackgroundImage(weather: weather.weather?.first?.main ?? "")
                self?.placeLabel.text = weather.name ?? ""
                self?.checkWeatherForDays()
            }
        }
    }
    
    func checkWeatherForDays(){
        NetworkManager().getWeatherForNextDays(lon: "\(currentWeather?.coord?.lon ?? 0)", lat: "\(currentWeather?.coord?.lat ?? 0)") { [weak self] (weatherDaily) in
            self?.dailyWeather = weatherDaily
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func setBackgroundImage(weather: String){
        print(weather)
        switch weather {
        case "Drizzle":
            self.weatherImageView.image = UIImage(named: "Drizzle")
        case "Thunderstorm":
            self.weatherImageView.image = UIImage(named: "Thundering")
        case "Rain":
            self.weatherImageView.image = UIImage(named: "Rainy")
        case "Snow":
            self.weatherImageView.image = UIImage(named: "Snowing")
        case "Clouds":
            self.weatherImageView.image = UIImage(named: "Cloudy")
        case "Clear":
            self.weatherImageView.image = UIImage(named: "ClearSky")
        default:
            print("error")
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        checkWeather(placeName: searchBar.text ?? "")
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        checkWeather(placeName: searchBar.text ?? "")
        save(text: searchBar.text ?? "")
    }
    
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

