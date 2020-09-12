//
//  UIViewController+Extension.swift
//  weatherGR
//
//  Created by Roman Varga on 12/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static let loaderTag = 12345
    
    private var loaderView: UIView? {
        return view.viewWithTag(BasicViewController.loaderTag)
    }
}
