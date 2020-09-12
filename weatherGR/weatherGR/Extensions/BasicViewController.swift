//
//  ViewController+Extension.swift
//  weatherGR
//
//  Created by Roman Varga on 11/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {
    
    weak var scrollViewForKeyboard: UIScrollView?
    var sideMenuFlow = false
    var keyboardCancelTap: UITapGestureRecognizer?
    var keyboardCancelExcludedViews: [UIView]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardCancelTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        keyboardCancelTap?.cancelsTouchesInView = false
        keyboardCancelTap?.delegate = self
        view.addGestureRecognizer(keyboardCancelTap!)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    // MARK: Keyboard handling
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BasicViewController.keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BasicViewController.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        scrollViewForKeyboard?.contentInset = contentInsets
        scrollViewForKeyboard?.scrollIndicatorInsets = contentInsets
        
        let firstResponder = view.findFirstResponder()
        scrollToVisible(view: firstResponder)
    }
    
    func scrollToVisible(view: UIView?) {
        guard let scrollView = scrollViewForKeyboard, let view = view else {
            return
        }
        let frameInContentView = view.superview!.convert(view.frame, to: scrollViewForKeyboard)
        
        var bottomY = frameInContentView.origin.y + frameInContentView.size.height - 40
        if bottomY > scrollView.contentSize.height {
            bottomY = scrollView.contentSize.height
        }
        let scrollRect = CGRect(x: 0, y: bottomY - 1, width: 1, height: 1)
        scrollView.scrollRectToVisible(scrollRect, animated: true)
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollViewForKeyboard?.contentInset = UIEdgeInsets.zero
        scrollViewForKeyboard?.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BasicViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == keyboardCancelTap {
            if let touchView = touch.view, let keyboardCancelExcludedViews = keyboardCancelExcludedViews {
                for excludedView in keyboardCancelExcludedViews {
                    if touchView.isDescendant(of: excludedView) {
                        return false
                    }
                }
            }
        }
        return true
    }
}

