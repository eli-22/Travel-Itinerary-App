//
//  SavedPlacesMapViewModel.swift
//  ItineraryMap
//
//  Created by Elise on 2/19/23.
//

import SwiftUI
import MapKit
import Combine
import GooglePlaces

@MainActor
class SavedPlacesMapViewModel: Hashable, ObservableObject {
    
    // Needed to conform to Hashable
    var id = UUID()
    
    // Needed to track user's location
    var cancellable: AnyCancellable?
    @Published var currentLocation: CLLocationCoordinate2D?
    
    // Coordinate for the trip location (not necessarily the user's location)
    @Published var tripLocation: CLLocationCoordinate2D?
    
    @Published var places = [PlaceViewModel]()
    @Published var savedLocations = [Location]()
    
    // Needed to show detail view.
    // Optional because no location is selected initially.
    @Published var selectedLocation: Location?
    
    // No detail view showing when the map first loads. When the user selects a pin, this flips to true.
    @Published var isShowingDetailView = false
    
    init() {
        cancellable = LocationManager.sharedLocationManager.$location.sink { location in
            if let location = location {
                DispatchQueue.main.async {
                    self.currentLocation = location.coordinate
                }
            }
        }
    }
    
    func getPlaces(tripVM: TripViewModel) {
        DispatchQueue.main.async {
            // This will be an array of Place View Models.
            // Iterate through the array and call the init method for each one.
            self.places = Place.getPlacesByTripId(tripId: tripVM.tripId).map(PlaceViewModel.init)
            print("---- GET PLACES ----")
        }
        
    }
    
    func convertPlaceToLocation(places: [PlaceViewModel]) {
        for place in places {
            let savedLocation = Location(
                placeID: place.gmsID,
                name: place.name,
                address: place.address,
                coordinate: place.mapCoordinate)
            self.savedLocations.append(savedLocation)
            print(" ----- GET LOCATIONS ------")
        }
    }
    
    // Map will center on first saved place if it exists.
    // If not, it will center on trip's saved location.
    // Otherwise, will center on default location.
    
    func updateSavedPlaces(currentTrip: TripViewModel) -> Binding<MKCoordinateRegion> {
        if let firstSaved = currentTrip.savedLocations.first?.coordinate {
            print(firstSaved)
            return .constant(MKCoordinateRegion(center: firstSaved, span: MapDefaults.defaultSpan))
        }
        else if let tripLocation = tripLocation {
            print(tripLocation)
            return .constant(MKCoordinateRegion(center: tripLocation, span: MapDefaults.defaultSpan))
        }
        else {
            return .constant(MKCoordinateRegion(center: MapDefaults.defaultLocation, span: MapDefaults.defaultSpan))
        }
    }
    
    // Needed to conform to Hashable.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SavedPlacesMapViewModel, rhs: SavedPlacesMapViewModel) -> Bool {
        return (lhs.id == rhs.id)
    }

}
