//
//  InitialViewController+Functionality.swift
//  weatherGR
//
//  Created by Roman Varga on 11/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit

extension ViewController: HistoryRowPressedProtocolDelegate {
    func historyRowPressed(placeName: String) {
        checkWeather(placeName: placeName)
    }
    
    
    /// WeatherAPI call by place name then setup for whole view
    /// - Parameter placeName: City/place name
    func checkWeather(placeName: String) {
        self.showLoader()
        self.save(text: placeName)
        NetworkManager().getActualWeather(placeName: placeName) { [weak self] (weather) in
            self?.currentWeather = weather
            DispatchQueue.main.async {
                self?.checkWeatherForDays()
            }
        }
        self.hideLoader()
    }
    
    /// WeatherAPI call by coordinates then setup for whole view
    /// - Parameters:
    ///   - lat: latitude
    ///   - lon: longitude
    func checkWeather(lat: String, lon: String) {
        self.showLoader()
        NetworkManager().getActualWeather(lat: lat, lon: lon) { [weak self] (weather) in
            self?.currentWeather = weather
            DispatchQueue.main.async {
                self?.checkWeatherForDays()
                self?.save(text: weather.name ?? "")
            }
        }
        self.hideLoader()
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
