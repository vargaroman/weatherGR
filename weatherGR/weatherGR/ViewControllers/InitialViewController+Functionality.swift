//
//  InitialViewController+Functionality.swift
//  weatherGR
//
//  Created by Roman Varga on 11/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit

extension ViewController {
    
    /// Function for icon selection in tableview for nextdays forecast
    /// - Parameter forecast: String which describe weather
    /// - Returns: name of imageIcon
    func getForecastIcon(forecast: String)->String{
        switch forecast {
            case "Drizzle":
                return "RainIcon"
            case "Thunderstorm":
                return "RainIcon"
            case "Rain":
                return "RainIcon"
            case "Snow":
                return "SnowIcon"
            case "Clouds":
                return "RainIcon"
            case "Clear":
                return "SunnyIcon"
            default:
                return "questionMarkIcon"

        }
    }
    
    /// Function set app background
    /// - Parameter weather: weather description string
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
    
    /// WeatherAPI call by place name then setup for whole view
    /// - Parameter placeName: City/place name
    func checkWeather(placeName: String) {
        NetworkManager().getActualWeather(placeName: placeName) { [weak self] (weather) in
            self?.currentWeather = weather
            DispatchQueue.main.async {
                self?.setBackgroundImage(weather: weather.weather?.first?.main ?? "")
                self?.checkWeatherForDays()
            }
        }
    }
    
    /// WeatherAPI call by coordinates then setup for whole view
    /// - Parameters:
    ///   - lat: latitude
    ///   - lon: longitude
    func checkWeather(lat: String, lon: String) {
        NetworkManager().getActualWeather(lat: lat, lon: lon) { [weak self] (weather) in
            self?.currentWeather = weather
            DispatchQueue.main.async {
                self?.setBackgroundImage(weather: weather.weather?.first?.main ?? "")
                self?.checkWeatherForDays()
            }
        }
    }
    
    /// WeatherAPI call by coordinates which returns weather for next 7 days then setup tableview
    func checkWeatherForDays(){
        NetworkManager().getWeatherForNextDays(lon: "\(currentWeather?.coord?.lon ?? 0)", lat: "\(currentWeather?.coord?.lat ?? 0)") { [weak self] (weatherDaily) in
            self?.dailyWeather = weatherDaily
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}
