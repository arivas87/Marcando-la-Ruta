//
//  ViewController.swift
//  Marcando la Ruta
//
//  Created by Arturo Rivas on 11/5/16.
//  Copyright © 2016 Arturo Rivas. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var lastLocation: CLLocation?
    var distancia: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cambioSelector(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Satellite
        case 2:
            mapView.mapType = .Hybrid
        default:
            print("Index error")
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
            mapView.showsUserLocation = true
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            mapView.region = MKCoordinateRegion(center: mapView.centerCoordinate, span: span)
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = manager.location
        mapView.centerCoordinate = location!.coordinate
        
        if lastLocation == nil || location?.distanceFromLocation(lastLocation!) > 50 {
            let pin = MKPointAnnotation()
            let coordinate = location!.coordinate
            pin.coordinate = coordinate
            pin.title = "(\(coordinate.longitude), \(coordinate.latitude))"
            distancia += lastLocation != nil ? location!.distanceFromLocation(lastLocation!) : 0
            pin.subtitle = "\(Int(distancia)) metros"
            
            mapView.addAnnotation(pin)
            lastLocation = location
        }
    }

}

