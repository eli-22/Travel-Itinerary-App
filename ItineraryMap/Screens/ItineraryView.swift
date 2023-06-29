//
//  ItineraryView.swift
//  ItineraryMap
//
//  Created by Elise on 2/18/23.
//

import SwiftUI

struct ItineraryView: View {
    
    let tripVM: TripViewModel
    @StateObject private var itineraryVM = ItineraryViewModel()
    @StateObject private var placeManager = PlacesManager.sharedPlacesManager
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Itinerary Details")) {
                    ForEach(itineraryVM.savedPlaces, id: \.placeId) { savedPlace in
                            
                            let location = Location(
                                placeID: savedPlace.gmsID,
                                name: savedPlace.name,
                                address: savedPlace.address,
                                coordinate: savedPlace.mapCoordinate)
                        
                            LocationCell(location: location)
                                .listRowSeparator(.visible)
                                .onDisappear() {
                                    itineraryVM.selectedSavedPlace = location
                                    placeManager.getPlacePhotos(placeID: location.placeID) {
                                    }
                                    
                                }
                        
                    }
                    .onDelete(perform: { indexSet in
                        itineraryVM.deletePlace(at: indexSet)
                        itineraryVM.showPlaces(tripVM: tripVM)
                    })
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle(tripVM.name)
            .onAppear() {
                itineraryVM.showPlaces(tripVM: tripVM)
                placeManager.imageArray = []
            }
        }
    }
}
