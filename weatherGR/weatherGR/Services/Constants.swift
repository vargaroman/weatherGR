//
//  Constants.swift
//  weatherGR
//
//  Created by Roman Varga on 10/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class Constants {
    //weather API key
    static let weatherKey = "weatherAPIKey"
    
    
    func setWeatherApiKey(apiKey: String) {
        KeychainWrapper.standard.set("31ef20f69ed85353c00e386a29d49927", forKey: Constants.weatherKey)
    }
    func getWeatherApiKey() -> String? {
        return KeychainWrapper.standard.string(forKey: Constants.weatherKey)
    }
    
    static let weatherAPIKey = "31ef20f69ed85353c00e386a29d49927"
    static let weatherAPILink = "https://api.openweathermap.org/data/2.5/weather?"
    static let forecastAPILink = "https://api.openweathermap.org/data/2.5/forecast?"
    static let oneCallAPILink = "https://api.openweathermap.org/data/2.5/onecall?"
    
    static let googleStaticMapApiKey = "AIzaSyB__sK-LxxygkRXbqu7y8nHF1Zu9RcyqgU"
    static let googleStaticMapApiLink = "https://maps.googleapis.com/maps/api/staticmap?"
    
}
