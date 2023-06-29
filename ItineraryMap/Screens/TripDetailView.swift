//
//  TripDetailView.swift
//  ItineraryMap
//
//  Created by Elise on 2/2/23.
//

import Foundation
import SwiftUI

struct TripDetailView: View {
    
    @State var tripVM: TripViewModel
    @StateObject private var tripDetailVM = TripDetailViewModel()
    @StateObject var placeManager = PlacesManager.sharedPlacesManager
    
    var body: some View {
        
        VStack {
            Text(tripVM.name)
                .font(.title)
                .fontWeight(.semibold)
                .padding(10)
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.red)
                Text(tripVM.locationName ?? "")
            }
            Text("\(tripVM.startDate ?? "") - \(tripVM.endDate ?? "")")
                .padding(10)
            Text ("Let's plan your trip!")
                .font(.subheadline)
                .fontWeight(.light)
            
            NavigationView {
                VStack {
                    List {
                        ForEach(placeManager.suggestedLocations) { location in
                            LocationCell(location: location)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    tripDetailVM.selectedLocation = location
                                    placeManager.getPlacePhotos(placeID: location.placeID) {
                                        tripDetailVM.isShowingDetailView = true
                                    }
                                    
                                }
                        }
                    }
                }.searchable(text: $tripDetailVM.searchString)
                    .onChange(of: tripDetailVM.searchString) { searchText in
                        if !searchText.isEmpty {
                            placeManager.displaySearchResults(searchQuery: tripDetailVM.searchString)
                        } else {
                            placeManager.suggestedLocations = []
                        }
                    }
            }
            NavigationLink(destination: NearbyMapView(currentTrip: tripVM)) {
                    HStack {
                        Text("Search Nearby")
                            .foregroundColor(.white)
                        Image(systemName: "location")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
            }
            .standardButtonStyle()
            .padding(.bottom, 10)
            
            Spacer()
            
            NavigationLink (destination:  UpdateTripView(currentTripVM: tripVM)) {
                AccentButton(buttonName: "Update Details")
            }
        }
        .sheet(isPresented: $tripDetailVM.isShowingDetailView) {
            // selectedPlace is optional > use a nil coalescing operator in case it is nil (but it won't be, because it has already been selected in order to show the detail view).
            PlaceDetailView(
                selectedLocation: tripDetailVM.selectedLocation ?? MockLocations.topRock,
                currentTrip: tripVM,
                mapVM: nil,
                tripVM: tripDetailVM)
        }
        .onAppear() {
            // Clear any previous suggestions.
            placeManager.suggestedLocations = []
        }
        .padding()
    }
    
}


struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailView(tripVM: TripViewModel(trip: Trip(context: CoreDataManager.shared.viewContext)))
    }
}

