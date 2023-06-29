//
//  AllTripsView.swift
//  ItineraryMap
//
//  Created by Elise on 2/14/23.
//

import SwiftUI

struct AllTripsView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    
    //@StateObject property wrapper ensures the instance doesn't get destroyed when the view updates. Used when you need to create a reference type inside one of your views and make sure it stays alive for use in that view and others you share it with.
    @StateObject private var allTripsVM = AllTripsViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    allTripsVM.displayAllTrips(userVM: loginVM.userVM!)
                } label: {
                    HStack {
                        Text("Reset")
                            .font(.title3)
                        Image(systemName: "arrow.counterclockwise.circle")
                            .font(.title3)
                    }
                }.padding()
                
                Spacer()
                Button {
                    allTripsVM.isShowingSortOptions = true
                } label: {
                    HStack {
                        Text("Sort")
                            .font(.title3)
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.title3)
                    }
                }.padding(.trailing, 10)
                
                Button {
                    allTripsVM.isShowingFilterView = true
                } label: {
                    HStack {
                        Text("Filter")
                            .font(.title3)
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title3)
                    }
                }
            }.padding(.trailing)
            
            List {
                ForEach(allTripsVM.trips, id: \.tripId) { tripVM in
                    NavigationLink(destination: TripTabView(currentTripVM: tripVM)) {
                        TripCell(trip: tripVM)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                allTripsVM.selectedTrip = tripVM
                            }
                    }
                }
                .onDelete(perform: { indexSet in
                    allTripsVM.deleteTrip(at: indexSet)
                })
            }
            .listStyle(PlainListStyle())
            .navigationTitle("All Trips")
            .onAppear() {
                self.allTripsVM.setup(userVM: self.loginVM.userVM!)
                allTripsVM.displayAllTrips(userVM: loginVM.userVM!)
            }
        }
        .sheet(isPresented: $allTripsVM.isShowingFilterView) {
            FilterView(trips: $allTripsVM.trips, isShowingFilterView: $allTripsVM.isShowingFilterView)
        }
        if allTripsVM.isShowingSortOptions {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Spacer()
                        
                        //  Picker view has allTripsVM.selectedSortOption and selectedSortDirection. When user selects something from the picker view, the AllTripsViewModel has already populated these properties from the picker view, so there is no need to pass the selection to a sort function.
                        
                        Picker("Select Option", selection: $allTripsVM.selectedSortOption) {
                            ForEach(SortOptions.allCases, id: \.self) {
                                Text($0.displayText)
                            }
                        }.frame(width: geometry.size.width/2, height: 100)
                            .clipped()
                        
                        Picker("Sort Direction", selection: $allTripsVM.selectedSortDirection) {
                            ForEach(SortDirection.allCases, id: \.self) {
                                Text($0.displayText)
                            }
                        }.frame(width: geometry.size.width/2, height: 100)
                            .clipped()
                        
                        Spacer()
                    }
                    Button {
                        // Don't have to pass anything to this function because selectedSortOption and selectedSortDirection are binding properties, so the values are populated when they are selected.
                        allTripsVM.isShowingSortOptions = false
                        allTripsVM.sort()
                    } label: {
                        StandardButton(buttonName: "Sort")
                    }
                }
            }
        }
    }
}

struct AllTripsView_Previews: PreviewProvider {
    static var previews: some View {
        AllTripsView()
    }
}
