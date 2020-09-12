//
//  Array+Extension.swift
//  weatherGR
//
//  Created by Roman Varga on 12/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import Foundation

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
