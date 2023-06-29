//
//  ContentView.swift
//  ItineraryMap
//
//  Created by Elise on 2/1/23.
//

import SwiftUI
import MapKit
import GooglePlaces

struct NearbyMapView: View {
    
    // I need to the current trip view model in order to add specific places to an itinerary.
    @State var currentTrip: TripViewModel
    @StateObject private var nearbyMapVM = NearbyMapViewModel()
    @StateObject private var placeManager = PlacesManager.sharedPlacesManager
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    var body: some View {
        ZStack (alignment: .top) {
            if nearbyMapVM.isShowingNearby {
                Map(coordinateRegion: nearbyMapVM.updateNearbyPlaces(),
                    showsUserLocation: true,
                    userTrackingMode: $userTrackingMode,
                    annotationItems: placeManager.nearbyLocations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        NearbyMapPin(location: location)
                            .onTapGesture {
                                nearbyMapVM.selectedLocation = location
                                placeManager.getPlacePhotos(placeID: location.placeID) {
                                    nearbyMapVM.isShowingDetailView = true
                                }
                            }
                    }
                }
            }
            else  {
                Map(coordinateRegion: nearbyMapVM.updateMapRegion(),
                    showsUserLocation: true,
                    userTrackingMode: $userTrackingMode)
            }
            VStack {
                Spacer()
                Button {
                    nearbyMapVM.isShowingNearby = true
                } label: {
                    AccentButton(buttonName: "See Nearby")
                        .padding(50)
                }
            }
        }
        // Make the location dot stand out against the map background.
        .accentColor(Color(.systemPink))
        
        // isPresented takes a boolean. $ is used for binding.
        // When isShowingDetailView changes to true, isPresented will change to true, and the detail view for the selected place will be presented.
        .sheet(isPresented: $nearbyMapVM.isShowingDetailView) {
            // selectedPlace is optional > use a nil coalescing operator in case it is nil (but it won't be, because it has already been selected in order to show the detail view). 
            PlaceDetailView(
                selectedLocation: nearbyMapVM.selectedLocation ?? MockLocations.topRock,
                currentTrip: currentTrip,
                mapVM: nearbyMapVM,
                tripVM: nil)
        }
    }
}
