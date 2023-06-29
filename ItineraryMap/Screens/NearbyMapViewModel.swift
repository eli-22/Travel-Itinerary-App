//
//  NearbyMapViewModel.swift
//  ItineraryMap
//
//  Created by Elise on 2/8/23.
//

import SwiftUI
import MapKit
import Combine
import GooglePlaces

@MainActor
class NearbyMapViewModel: Hashable, ObservableObject {
    
    // Needed to conform to Hashable
    var id = UUID()
    
    // Needed to track user's location
    var cancellable: AnyCancellable?
    @Published var currentLocation: CLLocationCoordinate2D?
    
    // Coordinate for the trip location (not necessarily the user's location)
    @Published var tripLocation: CLLocationCoordinate2D?
    
    // Needed to load nearby locations from API call
    @Published var nearbyLocations = PlacesManager.sharedPlacesManager.nearbyLocations
    
    // When user presses "Show Nearby," this will flip to true.
    @Published var isShowingNearby = false
    
    // Needed to show detail view and add place to itinerary.
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
    
    // Call this when the map loads. 
    func updateMapRegion() -> Binding<MKCoordinateRegion> {
        guard let coordinate = currentLocation else {
            return .constant(MapDefaults.defaultRegion)
        }
        return .constant(MKCoordinateRegion(center: coordinate, span: MapDefaults.defaultSpan))
    }
    
    // Call this when the user presses "See Nearby." The only difference is the zoom, because Google Places API usually only shows places within a few blocks. (But this is too zoomed in for when the map first loads; you can't see where you are.)
    func updateNearbyPlaces() -> Binding<MKCoordinateRegion> {
        guard let coordinate = currentLocation else {
            return .constant(MapDefaults.defaultRegion)
        }
        return .constant(MKCoordinateRegion(center: coordinate, span: MapDefaults.nearbyDefaultSpan))
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
    
    // Needed to conform to Hashable.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: NearbyMapViewModel, rhs: NearbyMapViewModel) -> Bool {
        return (lhs.id == rhs.id)
    }
}
