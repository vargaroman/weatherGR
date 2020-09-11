//
//  Integer+Extension.swift
//  weatherGR
//
//  Created by Roman Varga on 10/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import Foundation

extension Double{
    func getStringDateFromTimeStamp() -> String {
        let date = NSDate(timeIntervalSince1970: self)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd.M."
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    func getDateFromTimeStamp()->Date{
        let date = NSDate(timeIntervalSince1970: self)
        return date as Date
    }
}
