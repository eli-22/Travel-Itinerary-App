//
//  PlaceDetailView.swift
//  ItineraryMap
//
//  Created by Elise on 2/17/23.
//

import SwiftUI

struct PlaceDetailView: View {
    
    // I need the current location in order to get its name, address, and photos from the API. 
    // This is passed in when the view is created. (The user has selected the location.)
    let selectedLocation: Location
    
    // I need the current trip in order to add a location to the trip's itinerary.
    // This is passed in when the view is created from the NearbyMapView
    @State var currentTrip: TripViewModel
    
    // I need variables and functions from the view model that presented this detail view.
    // This may be a TripDetailView or a NearbyMapViewModel.
    // This view needs to update the view model's isShowingDetailView when the user dismisses the detail view.
    // It also needs to call the addPlaceToTrip function in case the user chooses "Add to Itinerary."
    let mapVM: NearbyMapViewModel?
    let tripVM: TripDetailViewModel?
    
    @StateObject var placeManager = PlacesManager.sharedPlacesManager
    
    let columns: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            VStack (alignment: .center) {
                Text(selectedLocation.name)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                Text(selectedLocation.address)
                    .padding(.bottom, 10)
                
                // Dismiss the detail view if the user adds the place to their itinerary.
                Button {
                    mapVM?.isShowingDetailView = false
                    mapVM?.addPlaceToTrip(currentTripViewModel: currentTrip)
                    tripVM?.isShowingDetailView = false
                    tripVM?.addPlaceToTrip(currentTripViewModel: currentTrip)
                    placeManager.savedLocations.append(selectedLocation)
                } label: {
                    StandardButton(buttonName: "Add to Itinerary")
                }.padding(.bottom, 10)
                
                LazyVGrid(columns: columns) {
                    ForEach(placeManager.imageArray, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .onDisappear() {
            placeManager.suggestedLocations = []
            tripVM?.searchString = ""
            placeManager.imageArray = []
        }
        .padding(30)
    }
}
