//
//  MapViewController.swift
//  weatherGR
//
//  Created by Roman Varga on 11/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit
import MapKit

protocol MapPressedDelegate {
    func passImageToTable(coordinates: CLLocationCoordinate2D, mapImage: UIImage)
}

class MapViewController: BasicViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var mapPressedDelegate: MapPressedDelegate?
    var rect = CGRect(x: 0, y: 0, width: 375, height: 140)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLocation()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(getCoordinatePressOnMap(sender:)))
        gestureRecognizer.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(gestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @objc func getCoordinatePressOnMap(sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        mapView.addAnnotation(annotation)
        
        let snapshotOptions = MKMapSnapshotter.Options()
        snapshotOptions.region = .init(center: locationCoordinate, span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
        snapshotOptions.scale = UIScreen.main.scale
        snapshotOptions.size = CGSize(width: 350, height: 150)
        let mapSnapshotter = MKMapSnapshotter.init(options: snapshotOptions)
        mapSnapshotter.start(with: DispatchQueue.main) { (snapshot, error) in
            if let snapshot = snapshot {
                let image = UIGraphicsImageRenderer(size: snapshotOptions.size).image { _ in
                    snapshot.image.draw(at: .zero)
                    let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                    let pinImage = pinView.image
                    var point = snapshot.point(for: locationCoordinate)
                    if self.rect.contains(point) {
                        point.x -= pinView.bounds.width / 2
                        point.y -= pinView.bounds.height / 2
                        point.x += pinView.centerOffset.x
                        point.y += pinView.centerOffset.y
                        pinImage?.draw(at: point)
                    }
                }
                self.mapPressedDelegate?.passImageToTable(coordinates: locationCoordinate, mapImage: image)
                self.tabBarController?.selectedIndex = 0
                self.mapView.removeAnnotation(annotation)
            } else {
                print("oooops")
            }
        }
    }
    
    func getCurrentLocation(){
        if let currentLocationCoordinates = LocationManager.shared.coordinates {
            mapView.setCenter(currentLocationCoordinates, animated: true)
            let clLocation = CLLocation(latitude: currentLocationCoordinates.latitude, longitude: currentLocationCoordinates.longitude)
            mapView.centerToLocation(clLocation, regionRadius: 20000)
            mapView.showsUserLocation = true
        }
    }
}

extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
