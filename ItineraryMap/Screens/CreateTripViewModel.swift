//
//  CreateTripViewModel.swift
//  ItineraryMap
//
//  Created by Elise on 2/5/23.
//

import Foundation

@MainActor
class CreateTripViewModel: Hashable, ObservableObject {
    
    var id = UUID()
    var name: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    var userVM: UserViewModel?
    @Published var location = MockLocations.washSquare
    
    @Published var tripIsSaved = false
    @Published var selectedLocation: Location?
    @Published var locationIsSelected = false
    
    func setup(userVM: UserViewModel) {
        self.userVM = userVM
      }
    
    func saveTrip() {
        
        let manager = CoreDataManager.shared
        
        // Trip class is automatically generated based on the model file.
        let trip = Trip(context: manager.persistentContainer.viewContext)
        
        trip.name = name
        trip.startDate = startDate
        trip.endDate = endDate
        trip.latitude = location.coordinate.latitude
        trip.longitude = location.coordinate.longitude
        trip.user = userVM!.user
        
        // Don't want to display the default location name on the trip detail page if the user hasn't chosen a specific location.
        if locationIsSelected {
            trip.locationName = location.name
        } else { trip.locationName = "Location is a mystery!" }
        
        // Persists the data.
        // Need to implement this function in Core Data Manager class.
        manager.save()
    }
    
    // Need these to use Navigation Stack
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: CreateTripViewModel, rhs: CreateTripViewModel) -> Bool {
        return (lhs.id == rhs.id)
    }
    
}
