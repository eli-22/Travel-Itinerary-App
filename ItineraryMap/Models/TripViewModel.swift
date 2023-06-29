//
//  TripViewModel.swift
//  ItineraryMap
//
//  Created by Elise on 2/14/23.
//

import SwiftUI
import MapKit
import CoreData

struct TripViewModel {
    
    let trip: Trip
    
    var tripId: NSManagedObjectID { // Unique id for each object.
        return trip.objectID
    }
    
    var name: String {
        return trip.name ?? ""
    }
    
    var startDate: String? {
        return trip.startDate?.asFormattedString()
    }
    
    var endDate: String? {
        return trip.endDate?.asFormattedString()
    }
    
    var locationName: String? {
        return trip.locationName ?? ""
    }
    
    var mapCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: trip.latitude, longitude: trip.longitude)
    }
    
    var savedLocations: [Location] {
        return convertPlaceToLocation(places: trip.places!)
    }
    
    func convertPlaceToLocation(places: NSSet) -> [Location] {
        var locations = [Location]()
        for place in places {
            let location = Location(
                placeID: (place as! Place).gmsID ?? "",
                name: (place as! Place).name ?? "",
                address: (place as! Place).address ?? "",
                coordinate: CLLocationCoordinate2D(latitude: (place as! Place).latitude, longitude: (place as! Place).longitude))
            locations.append(location)
        }
        print(" ----- GET LOCATIONS ------")
        return locations
    }
}
