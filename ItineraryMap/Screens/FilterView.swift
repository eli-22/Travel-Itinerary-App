//
//  FilterView.swift
//  ItineraryMap
//
//  Created by Elise on 2/18/23.
//

import SwiftUI

struct FilterView: View {
    
    // Binding expressions reflect filters in the view that passed in the values (the previous screen).
    @Binding var trips: [TripViewModel]
    @Binding var isShowingFilterView: Bool

    @StateObject private var filterVM = FilterViewModel()
    
    // Use these variables to filter.
    @State private var tripName: String = ""
    @State private var tripStartDate = Date()
    @State private var firstDate = Date()
    @State private var lastDate = Date()
    
    var body: some View {
        Form {
            Section(header: Text("Search by Trip Name")) {
                
                // Just replacing text field with custom ZStack so the placeholder color matches the DatePicker placeholder color.
                ZStack (alignment: .leading) {
                    if tripName.isEmpty {
                        Text("Enter trip name:")
                            .foregroundColor(.black)
                    }
                    TextField("", text: $tripName)
                }
                    
                HStack {
                    Spacer()
                    Button{
                        // Calls the function in the view model, which in turn calls the corresponding function in the Trip class, which saves changes using the Core Data Manager.
                        trips = filterVM.filterTripsByName(name: tripName)
                        // Dismiss the filter view and go back to the trips view (which will display filtered results).
                        isShowingFilterView = false
                    } label: {
                        StandardButton(buttonName: "Filter")
                    }
                    Spacer()
                }
            }
            
            Section(header: Text("Show trips starting after:")) {
                DatePicker("Enter date:", selection: $tripStartDate, displayedComponents: .date)
                HStack {
                    Spacer()
                    Button{
                        // Bindable expression, so AllTripsView will also be updated if this changes.
                        trips = filterVM.filterTripsByStartDate(date: tripStartDate)
                        isShowingFilterView = false
                    } label: {
                        StandardButton(buttonName: "Filter")
                    }
                    Spacer()
                }
            }
            
            Section(header: Text("Search by Date Range")) {
                DatePicker("Trips starting after:", selection: $firstDate, displayedComponents: .date)
                DatePicker("Trips starting before:", selection: $lastDate, displayedComponents: .date)
                HStack {
                    Spacer()
                    Button{
                        let lowerBoundDate = firstDate
                        let upperBoundDate = lastDate
                        
                        trips = filterVM.filterTripsByDateRange(lowerBoundDate: lowerBoundDate, upperBoundDate: upperBoundDate)
                        
                        isShowingFilterView = false
                    } label: {
                        StandardButton(buttonName: "Filter")
                    }
                    Spacer()
                }
            }
        }
        .navigationTitle("Filters")
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(trips: .constant([TripViewModel(trip: Trip())]), isShowingFilterView: .constant(true))
    }
}
