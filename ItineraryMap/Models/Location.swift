//
//  Location.swift
//  ItineraryMap
//
//  Created by Elise on 2/16/23.
//

import Foundation
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let placeID: String
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
}

struct MockLocations {
    
    static let topRock = Location(
        placeID: "1",
        name: "Top of the Rock",
        address: "123 ABC",
        coordinate: CLLocationCoordinate2D(latitude: 40.759528, longitude: -73.979323))
    static let washSquare = Location(
        placeID: "2",
        name: "Washington Square Park",
        address: "123 ABC",
        coordinate: CLLocationCoordinate2D(latitude: 40.730785, longitude: -73.997684))
    
    static let dummyLocations: [Location] = [topRock, washSquare]
}

enum MapDefaults {
    // Map default location = downtown MTL
    static let defaultLocation = CLLocationCoordinate2D(latitude: 45.5019, longitude: -73.5674)
    
    // Default span for loading the map with trip view or user's location.
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    
    // Google Places API only shows places within a few blocks. Zoom in when user selects "Show nearby."
    static let nearbyDefaultSpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.003)
    
    static let defaultRegion = MKCoordinateRegion(
        center: MapDefaults.defaultLocation,
        span: MapDefaults.defaultSpan)
}
