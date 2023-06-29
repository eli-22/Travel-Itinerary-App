//
//  PlaceViewModel.swift
//  ItineraryMap
//
//  Created by Elise on 2/18/23.
//

import CoreData
import MapKit

struct PlaceViewModel {
    
    let place: Place
    
    var gmsID: String {
        return place.gmsID ?? ""
    }
    
    var placeId: NSManagedObjectID {
        return place.objectID
    }
    
    var name: String {
        return place.name ?? ""
    }
    
    var address: String {
        return place.address ?? ""
    }
    
    var mapCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
    }
}
