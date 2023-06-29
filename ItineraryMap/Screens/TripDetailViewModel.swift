//
//  TripDetailViewModel.swift
//  ItineraryMap
//
//  Created by Elise on 2/13/23.
//

import SwiftUI
import GooglePlaces

@MainActor
class TripDetailViewModel: ObservableObject {
    
    @Published var trip: Trip?
    @Published var itinerary = [Location]()
    
    @Published var suggestedPlaceIDs = [String]()
    @Published var suggestedLocations = [Location]()
    
    // Needed to show detail view and potentially add place to itinerary.
    // Optional because no location is selected initially.
    @Published var selectedLocation: Location?
    
    // Detail view will show when the user selects a location from search suggestions.
    @Published var isShowingDetailView = false
    
    @Published var searchString: String = ""
    
    func displaySearchResults(searchQuery: String?) {
        
        guard let query = searchQuery,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        PlacesManager.sharedPlacesManager.searchPlaces(query: query) { result in
            switch result {
            case .success(let places):
                print(places)
                self.suggestedPlaceIDs = places
                print("-----PLACE IDS------")
                print(self.suggestedPlaceIDs)
                self.getSuggestedPlaces(placeIdArray: self.suggestedPlaceIDs)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getSuggestedPlaces(placeIdArray: [String]) {
        
        for place in placeIdArray {
            PlacesManager.sharedPlacesManager.getLocationByID(placeID: place)
        }
    }
    
    func addPlaceToTrip(currentTripViewModel: TripViewModel) {
        
        // Pass in the current TripViewModel so we can assign the new place to the correct Trip object in the database.
        let trip = CoreDataManager.shared.findTripById(id: currentTripViewModel.tripId)
        
        // Place class was automatically generated when we selected "Class Definition" under "Codegen" in the model.
        let newPlace = Place(context: CoreDataManager.shared.viewContext)
        
        // Assign values from selected location to new place.
        newPlace.name = selectedLocation?.name
        newPlace.address = selectedLocation?.address
        newPlace.gmsID = selectedLocation?.placeID
        newPlace.latitude = selectedLocation?.coordinate.latitude ?? MapDefaults.defaultLocation.latitude
        newPlace.longitude = selectedLocation?.coordinate.longitude ?? MapDefaults.defaultLocation.longitude
        
        // Assign the new place to the current trip. We can do this because we specified an inverse relationship.
        newPlace.trip = trip
        
        // Save everything in the Managed Object Context.
        CoreDataManager.shared.save()
    }
}
