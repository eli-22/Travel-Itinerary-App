//
//  FilterViewModel.swift
//  ItineraryMap
//
//  Created by Elise on 2/18/23.
//

import SwiftUI

class FilterViewModel: ObservableObject {
    
    // Need to call each of the functions in Trip+Ext from inside the FilterViewModel.
    
    func filterTripsByName(name: String) -> [TripViewModel] {
        return Trip.filterTripsByName(name: name).map(TripViewModel.init)
    }
    
    func filterTripsByStartDate(date: Date) -> [TripViewModel] {
        return Trip.filterTripsStartingAfterDate(date: date).map(TripViewModel.init)
    }
    
    func filterTripsByDateRange(lowerBoundDate: Date, upperBoundDate: Date) -> [TripViewModel] {
        return Trip.filterTripsByDateRange(lower: lowerBoundDate, upper: upperBoundDate).map(TripViewModel.init)
    }
}
