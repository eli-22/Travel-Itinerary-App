//
//  CreateTripView.swift
//  ItineraryMap
//
//  Created by Elise on 2/5/23.
//

import SwiftUI

struct CreateTripView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    
    // View model contains all the properties where we can send the values the user inputs.
    @StateObject private var createTripVM = CreateTripViewModel()
    @State private var searchString: String = ""
    @StateObject var placeManager = PlacesManager.sharedPlacesManager
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                // These are properties of the createTripVM instance.
                TextField("Enter trip name", text: $createTripVM.name)
                    .keyboardType(.default)
                DatePicker("Choose start date:", selection: $createTripVM.startDate, displayedComponents: .date)
                DatePicker("Choose end date:", selection: $createTripVM.endDate, displayedComponents: .date)
                Text("Choose a location:")
            }
            ZStack {
                NavigationView {
                    VStack {
                        List {
                            ForEach(placeManager.suggestedLocations) { location in
                                LocationCell(location: location)
                                    .listRowSeparator(.hidden)
                                    .onTapGesture {
                                        createTripVM.location = location
                                        createTripVM.selectedLocation = location
                                        createTripVM.locationIsSelected = true
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
                
                if createTripVM.locationIsSelected {
                    ZStack {
                        Rectangle()
                            .fill(.background)
                        VStack {
                            Text("Location has been set to:")
                                .padding(.bottom, 10)
                            Text(createTripVM.selectedLocation!.name)
                                .font(.largeTitle)
                                .foregroundColor(Color("brandPrimary"))
                        }
                    }
                }
                
                if createTripVM.tripIsSaved {
                    ZStack {
                        Rectangle()
                            .fill(.background)
                        Text("Trip Created!")
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
                    createTripVM.saveTrip()
                    createTripVM.tripIsSaved = true
                    
                    // Clear the suggestions for next time. 
                    placeManager.suggestedLocations = []
                } label: {
                    StandardButton(buttonName: "Create Trip")
                }
                Spacer()
            }
            NavigationLink (destination:  AllTripsView()) {
                AccentButton(buttonName: "Go to My Trips")
            }.padding()
            
        }
        .onAppear() {
            searchString = ""
            createTripVM.name = ""
            createTripVM.tripIsSaved = false
            createTripVM.locationIsSelected = false
            self.createTripVM.setup(userVM: self.loginVM.userVM!)
        }
        .padding()
        .navigationTitle("Add Trip")
    }
}

struct CreateTripView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTripView()
    }
}
