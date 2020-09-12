//
//  UIView+Extension.swift
//  weatherGR
//
//  Created by Roman Varga on 11/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit

extension UIView{
    func findFirstResponder() -> UIView? {
        return findFirstResponder(fromView: self)
    }
    
    private func findFirstResponder(fromView: UIView) -> UIView? {
        if fromView.isFirstResponder {
            return fromView
        }
        for view in fromView.subviews {
            if (view.isFirstResponder) {
                return view
            } else {
                let responderView = findFirstResponder(fromView: view)
                if responderView != nil {
                    return responderView
                }
            }
        }
        return nil
    }

    func bottomCornerRadius(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
