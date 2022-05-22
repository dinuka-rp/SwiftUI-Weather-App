//
//  LocationManager.swift
//  Weather
//
//  Created by Dinuka Piyadigama on 2022-05-22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        manager.stopUpdatingLocation()
    }
}
