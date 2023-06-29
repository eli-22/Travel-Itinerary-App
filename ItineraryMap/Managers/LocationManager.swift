//
//  LocationManager.swift
//  ItineraryMap
//
//  Created by Elise on 2/8/23.
//

import MapKit

class LocationManager: NSObject, ObservableObject {
    
    // Must have a strong reference to location manager.
    static let sharedLocationManager = LocationManager()
    
    let manager = CLLocationManager()
    @Published var location: CLLocation? = nil
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        print("------ Location manager initialized ------")
    }
}

// We need this in order to assign the delegate to self.
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
       
            self.location = location
    }
}

