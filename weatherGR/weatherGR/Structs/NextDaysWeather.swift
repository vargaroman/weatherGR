//
//  RootClass.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 10, 2020

import Foundation

struct NextDaysWeather : Codable {

        let daily : [Daily]?
        let lat : Float?
        let lon : Float?
        let timezone : String?
        let timezoneOffset : Int?

        enum CodingKeys: String, CodingKey {
                case daily = "daily"
                case lat = "lat"
                case lon = "lon"
                case timezone = "timezone"
                case timezoneOffset = "timezone_offset"
        }
    
//        init(from decoder: Decoder) throws {
//                let values = try decoder.container(keyedBy: CodingKeys.self)
//                daily = try values.decodeIfPresent([Daily].self, forKey: .daily)
//                lat = try values.decodeIfPresent(Float.self, forKey: .lat)
//                lon = try values.decodeIfPresent(Float.self, forKey: .lon)
//                timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
//                timezoneOffset = try values.decodeIfPresent(Int.self, forKey: .timezoneOffset)
//        }

}
