//
//  Float+Extension.swift
//  weatherGR
//
//  Created by Roman Varga on 10/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import Foundation

extension Float {
    func getProbability() -> String{
        return String(format: "%0.f", self*100)+"%"
    }
}
