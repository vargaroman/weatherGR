//
//  History.swift
//  weatherGR
//
//  Created by Roman Varga on 12/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import Foundation

class History:Equatable {
    static func == (lhs: History, rhs: History) -> Bool {
        return lhs.city == rhs.city && lhs.date == rhs.date
    }
    
    
    var city: String
    var date: String
    
    init(city:String, date:String) {
        self.city = city
        self.date = date
    }
}
