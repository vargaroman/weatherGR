//
//  Int+Extension.swift
//  weatherGR
//
//  Created by Roman Varga on 12/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import Foundation

extension Int {
    func getWindDirection() -> String{
        let doubleValue = Double(self)
        if doubleValue>337.5 || doubleValue <= 22.5 {
            return "N"
        } else if doubleValue>22.5 && doubleValue <= 67.5 {
            return "NE"

        } else if doubleValue>67.5 && doubleValue <= 112.5 {
            return "E"

        } else if doubleValue>112.5 && doubleValue <= 157.5 {
            return "SE"

        } else if doubleValue>157.5 && doubleValue <= 202.5 {
            return "S"

        } else if doubleValue>202.5 && doubleValue <= 247.5 {
            return "SW"

        } else if doubleValue>247.5 && doubleValue <= 292.5 {
            return "W"
        } else {
            return "NW"
        }
    }
    
    func getDateFromTimeStamp()->Date{
        let date = NSDate(timeIntervalSince1970: Double(self))
        return date as Date
    }
    
    func getHourFromTimeStamp() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: self.getDateFromTimeStamp())
        return time
    }
}
