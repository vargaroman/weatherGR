//
//  LocationManager.swift
//  weatherGR
//
//  Created by Roman Varga on 10/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

        static let shared = LocationManager()
        var coordinates: CLLocationCoordinate2D?
        let locationManager : CLLocationManager
        var locationInfoCallBack: ((_ info:LocationInformation)->())!
        var authorizationStatusCallBack: ((_ status: CLAuthorizationStatus)->())?

        override init() {
            locationManager = CLLocationManager()
            super.init()
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
            locationManager.delegate = self
        }

        func start(locationInfoCallBack:@escaping ((_ info:LocationInformation)->()), authorizationStatusCallBack: ((_ status: CLAuthorizationStatus)->())? = nil, requestWhenInUse: Bool = false) {
            self.locationInfoCallBack = locationInfoCallBack
            self.authorizationStatusCallBack = authorizationStatusCallBack
            if requestWhenInUse {
                locationManager.requestWhenInUseAuthorization()
            } else {
                locationManager.requestAlwaysAuthorization()
            }
            locationManager.startUpdatingLocation()
        }

        func stop() {
            locationManager.stopUpdatingLocation()
        }
        
        func start() {
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let mostRecentLocation = locations.last else {
                return
            }
            print(mostRecentLocation)
            let info = LocationInformation()
            info.latitude = mostRecentLocation.coordinate.latitude
            info.longitude = mostRecentLocation.coordinate.longitude
            coordinates = mostRecentLocation.coordinate
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            authorizationStatusCallBack?(status)
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
            locationManager.stopUpdatingLocation()
        }
    }

    class LocationInformation {
        var latitude:CLLocationDegrees?
        var longitude:CLLocationDegrees?
        init(latitude:CLLocationDegrees? = Double(0.0),longitude:CLLocationDegrees? = Double(0.0)){
            self.latitude = latitude
            self.longitude = longitude
        }
    }

