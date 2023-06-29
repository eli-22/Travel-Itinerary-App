//
//  UpdateTripViewModel.swift
//  ItineraryMap
//
//  Created by Elise on 2/21/23.
//

import Foundation

@MainActor
class UpdateTripViewModel: Hashable, ObservableObject {
    
    var id = UUID()
    var name: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    @Published var selectedLocation: Location?
    @Published var newLocation: Location?
    
    @Published var tripIsUpdated = false
    @Published var locationIsUpdated = false
    
    
    func updateTrip(tripViewModel: TripViewModel) {
        
        let manager = CoreDataManager.shared
        
        let trip = tripViewModel.trip
        
        trip.name = name
        
        trip.startDate = startDate
        trip.endDate = endDate
        
        // If the location has not been updated, the name will stay as it is, whether that is the name of the previously selected location, or "Location is a mystery!" if no location was selected when the trip was created.
        if let newLocation {
            trip.latitude = newLocation.coordinate.latitude
            trip.longitude = newLocation.coordinate.longitude
            trip.locationName = newLocation.name
        }

        manager.save()
    }
    
    // Need these to use Navigation Stack
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: UpdateTripViewModel, rhs: UpdateTripViewModel) -> Bool {
        return (lhs.id == rhs.id)
    }
}
