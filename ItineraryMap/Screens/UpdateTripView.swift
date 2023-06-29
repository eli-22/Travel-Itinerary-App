//
//  UpdateTripView.swift
//  ItineraryMap
//
//  Created by Elise on 2/21/23.
//

import SwiftUI

struct UpdateTripView: View {
    
    @State var currentTripVM: TripViewModel
    @StateObject private var updateTripVM = UpdateTripViewModel()
    @State private var searchString: String = ""
    @StateObject var placeManager = PlacesManager.sharedPlacesManager
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                TextField(currentTripVM.name, text: $updateTripVM.name)
                    .keyboardType(.default)
                DatePicker("Update start date:",
                           selection: $updateTripVM.startDate,
                           displayedComponents: .date)
                DatePicker("Update end date:",
                           selection: $updateTripVM.endDate,
                           displayedComponents: .date)
                Text("Update location:")
            }
            ZStack {
                NavigationView {
                    VStack {
                        List {
                            ForEach(placeManager.suggestedLocations) { location in
                                LocationCell(location: location)
                                    .listRowSeparator(.hidden)
                                    .onTapGesture {
                                        updateTripVM.newLocation = location
                                        updateTripVM.selectedLocation = location
                                        updateTripVM.locationIsUpdated = true
                                        searchString = ""
                                    }
                            }
                        }
                    }.searchable(text: $searchString)
                        .onChange(of: searchString) { searchText in
                            if !searchText.isEmpty {
                                placeManager.displaySearchResults(searchQuery: searchString)
                            } else {
                                placeManager.suggestedLocations = []
                            }
                        }
                }
                
                if updateTripVM.locationIsUpdated {
                    ZStack {
                        Rectangle()
                            .fill(.background)
                        VStack {
                            Text("Location has been set to:")
                                .padding(.bottom, 10)
                            Text(updateTripVM.selectedLocation!.name)
                                .font(.largeTitle)
                                .foregroundColor(Color("brandPrimary"))
                        }
                    }
                }
                
                if updateTripVM.tripIsUpdated {
                    ZStack {
                        Rectangle()
                            .fill(.background)
                        Text("Trip Updated!")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("brandSecondary"))
                        Spacer()
                    }
                }
            }.padding(.bottom, 10)
                
            HStack {
                Spacer()
                Button {
                    updateTripVM.updateTrip(tripViewModel: currentTripVM)
                    updateTripVM.tripIsUpdated = true
                    
                    // Clear the suggestions for next time.
                    placeManager.suggestedLocations = []
                } label: {
                    StandardButton(buttonName: "Update Trip")
                }
                Spacer()
            }
            NavigationLink (destination:  AllTripsView()) {
                AccentButton(buttonName: "Go to My Trips")
            }.padding()
            
        }
        .onAppear() {
            searchString = ""
            updateTripVM.name = currentTripVM.name
            updateTripVM.tripIsUpdated = false
            updateTripVM.locationIsUpdated = false
        }
        .padding()
        .navigationTitle("Add Trip")
    }
}
