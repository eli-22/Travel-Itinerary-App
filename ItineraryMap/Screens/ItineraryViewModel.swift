//
//  ItineraryViewModel.swift
//  ItineraryMap
//
//  Created by Elise on 2/18/23.
//

import CoreData

@MainActor
class ItineraryViewModel: ObservableObject {
    
    @Published var savedPlaces = [PlaceViewModel]()
    
    @Published var selectedSavedPlace: Location?
    
    func showPlaces(tripVM: TripViewModel) {
        DispatchQueue.main.async {
            // This will be an array of Place View Models.
            // Iterate through the array and call the init method for each one.
            self.savedPlaces = Place.getPlacesByTripId(tripId: tripVM.tripId).map(PlaceViewModel.init)
        }
    }
    
    // Delete from the database.
    func deletePlace(place: PlaceViewModel) {
        let place = CoreDataManager.shared.findPlaceById(id: place.placeId)
        if let place {
            CoreDataManager.shared.deletePlace(place: place)
        }
    }
    
    // Delete from the view.
    func deletePlace(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let place = savedPlaces[index]
            deletePlace(place: place)
        }
    }
}

