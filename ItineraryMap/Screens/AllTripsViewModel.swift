//
//  AllTripsViewModel.swift
//  ItineraryMap
//
//  Created by Elise on 2/14/23.
//

import Foundation
import CoreData

@MainActor
class AllTripsViewModel: Hashable, ObservableObject {
    
    // Needed to conform to Hashable.
    var id = UUID()
    
    @Published var trips = [TripViewModel]()
    @Published var selectedTrip: TripViewModel?
    
    // When this updates to true, I use the selected trip variable (above) to show the detail view for that trip.
    @Published var isShowingTripDetail = false
    
    // When flipped to true (when "Filter" button is pressed), the filter view will pop up.
    @Published var isShowingFilterView = false
    
    // When flipped to true (when "Sort" button is pressed), the sort options will display.
    @Published var isShowingSortOptions: Bool = false
    
    // These properties bind to the UI, so when we select an option from the menu, that property is populated.
    @Published var selectedSortOption: SortOptions = .name
    @Published var selectedSortDirection: SortDirection = .ascending
    
    var userVM: UserViewModel?
    
    func setup(userVM: UserViewModel) {
        self.userVM = userVM
      }
    
    func displayAllTrips(userVM: UserViewModel) {
//        let allTrips = CoreDataManager.shared.displayAllTrips()
        let allTrips = CoreDataManager.shared.showTripsByUser(user: userVM.user)
        DispatchQueue.main.async {
            // This will be the array of Trip View Models.
            // Iterate through the array and call the init method for each one.
            self.trips = allTrips.map(TripViewModel.init)
        }
    }
    
    func filterTripsByName(name: String) -> [TripViewModel] {
        return Trip.filterTripsByName(name: name).map(TripViewModel.init)
    }
    
    // Delete from the database.
    func deleteTrip(trip: TripViewModel) {
        // This is a trip view model, not an actual trip object. We need a function to find a trip by id, which we add in the Core Data Manager.
        let trip = CoreDataManager.shared.findTripById(id: trip.tripId)
        if let trip {
            CoreDataManager.shared.deleteTrip(trip: trip)
        }
    }
    
    // Delete from the view.
    func deleteTrip(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let trip = trips[index]
            deleteTrip(trip: trip)
            displayAllTrips(userVM: userVM!)
        }
    }
    
    func sort() {
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        // Sorting with binding properties:
        request.sortDescriptors = [NSSortDescriptor (key: selectedSortOption.rawValue, ascending:
                                                        selectedSortDirection.value)]
        
        let fetchedResultsController: NSFetchedResultsController<Trip> =
        NSFetchedResultsController(fetchRequest: request, managedObjectContext:
                                    CoreDataManager.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        try? fetchedResultsController.performFetch()
        DispatchQueue.main.async {
            self.trips = (fetchedResultsController.fetchedObjects ?? []).map (TripViewModel.init)
        }
    }
    
    // Needs to conform to Hashable to use Navigation Stack.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: AllTripsViewModel, rhs: AllTripsViewModel) -> Bool {
        return (lhs.id == rhs.id)
    }
}

