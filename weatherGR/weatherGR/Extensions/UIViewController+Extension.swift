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
    
    func showLoader() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.color = UIColor.secondaryColor
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func hideLoader(animated: Bool = true) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
