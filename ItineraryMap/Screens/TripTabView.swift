//
//  TripTabView.swift
//  ItineraryMap
//
//  Created by Elise on 2/18/23.
//

import SwiftUI

struct TripTabView: View {
    
    let currentTripVM: TripViewModel
    
    var body: some View {
        TabView {
            TripDetailView(tripVM: currentTripVM)
                .tabItem { Label("Trip", systemImage: "airplane.departure") }
            ItineraryView(tripVM: currentTripVM)
                .tabItem { Label("Itinerary", systemImage: "list.star") }
            SavedPlacesMapView(currentTrip: currentTripVM)
                .tabItem { Label("Map", systemImage: "map") }
        }
    }
}
