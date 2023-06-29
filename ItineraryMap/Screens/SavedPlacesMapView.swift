//
//  SavedPlacesMapView.swift
//  ItineraryMap
//
//  Created by Elise on 2/19/23.
//

import SwiftUI
import MapKit
import GooglePlaces

struct SavedPlacesMapView: View {
    
    @State var currentTrip: TripViewModel
    @StateObject private var savedMapVM = SavedPlacesMapViewModel()
    @StateObject var placeManager = PlacesManager.sharedPlacesManager
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    var body: some View {
        ZStack (alignment: .top) {
                // Center the map around the first saved item if it exists.
                // If not, center on the trip's location.
                Map(coordinateRegion: savedMapVM.updateSavedPlaces(currentTrip: currentTrip),
                    showsUserLocation: true,
                    userTrackingMode: $userTrackingMode,
                    annotationItems: currentTrip.savedLocations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        SavedMapPin(location: location)
                        // Custom pins for each place in the view model's savedLocations array.
                            .onTapGesture {
                                // Will pass selected location to detail view.
                                savedMapVM.selectedLocation = location
                                // Will present sheet.
                                placeManager.getPlacePhotos(placeID: location.placeID) {
                                    savedMapVM.isShowingDetailView = true
                                }
                            }
                    }
                }
        }
        .accentColor(Color(.systemPink))
        .onAppear() {
            savedMapVM.tripLocation = currentTrip.mapCoordinate
        }
    }
}
 
