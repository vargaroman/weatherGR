//
//  Daily.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 10, 2020

import Foundation

struct Daily : Codable {

        let clouds : Int?
        let dewPoint : Float?
        let dt : Double?
        let feelsLike : FeelsLike?
        let humidity : Int?
        let pop : Float?
        let pressure : Int?
        let sunrise : Int?
        let sunset : Int?
        let temp : Temp?
        let uvi : Float?
        let weather : [Weather]?
        let windDeg : Int?
        let windSpeed : Float?

        enum CodingKeys: String, CodingKey {
                case clouds = "clouds"
                case dewPoint = "dew_point"
                case dt = "dt"
                case feelsLike = "feels_like"
                case humidity = "humidity"
                case pop = "pop"
                case pressure = "pressure"
                case sunrise = "sunrise"
                case sunset = "sunset"
                case temp = "temp"
                case uvi = "uvi"
                case weather = "weather"
                case windDeg = "wind_deg"
                case windSpeed = "wind_speed"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                clouds = try values.decodeIfPresent(Int.self, forKey: .clouds)
                dewPoint = try values.decodeIfPresent(Float.self, forKey: .dewPoint)
                dt = try values.decodeIfPresent(Double.self, forKey: .dt)
                feelsLike = try values.decodeIfPresent(FeelsLike.self, forKey: .feelsLike)

                humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
                pop = try values.decodeIfPresent(Float.self, forKey: .pop)
                pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
                sunrise = try values.decodeIfPresent(Int.self, forKey: .sunrise)
                sunset = try values.decodeIfPresent(Int.self, forKey: .sunset)
            temp = try values.decodeIfPresent(Temp.self, forKey: .temp)
                uvi = try values.decodeIfPresent(Float.self, forKey: .uvi)
                weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
                windDeg = try values.decodeIfPresent(Int.self, forKey: .windDeg)
                windSpeed = try values.decodeIfPresent(Float.self, forKey: .windSpeed)
        }

}
