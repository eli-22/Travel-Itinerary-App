//
//  SortingTools.swift
//  ItineraryMap
//
//  Created by Elise on 2/19/23.
//

enum SortOptions: String, CaseIterable {
    
    case name
    case startDate
    
    var displayText: String {
        switch self {
            case .name:
                return "Trip Name"
            case .startDate:
                return "Start Date"
        }
    }
}

enum SortDirection: CaseIterable {
    
    case ascending
    case descending
    
    var value: Bool {
        switch self {
            case .ascending:
                return true
            case .descending:
                return false
        }
    }
    
    var displayText: String {
        switch self {
            case .ascending:
                return "Ascending"
            case .descending:
                return "Descending"
        }
    }
}

