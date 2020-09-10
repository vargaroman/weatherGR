//
//  ViewController.swift
//  weatherGR
//
//  Created by Roman Varga on 09/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    var currentWeather: WeatherDetail2?
    var dailyWeather: [Daily]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        checkWeather(placeName: "London")
        // Do any additional setup after loading the view.
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
                self?.temperatureLabel.text = "\(weather.main?.temp ?? 0)"
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
            self.weatherImageView.image = UIImage(named: "Drizzle")
        case "Clouds":
            self.weatherImageView.image = UIImage(named: "Drizzle")
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
    }
}

