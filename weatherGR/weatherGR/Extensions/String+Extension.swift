//
//  String+Extension.swift
//  weatherGR
//
//  Created by Roman Varga on 12/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import Foundation

extension String {
    /// Function for icon selection in tableview for nextdays forecast
    /// - Parameter forecast: String which describe weather
    /// - Returns: name of imageIcon
    func getForecastIcon()->String{
        switch self {
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
    
    func replaceSpace() -> String{
        return self.replacingOccurrences(of: " ", with: "+")
    }
}
