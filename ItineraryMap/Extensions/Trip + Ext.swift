//
//  Trip + Ext.swift
//  ItineraryMap
//
//  Created by Elise on 2/17/23.
//

import CoreData

// Create an extension because the Trip class already exists. It was generated automatically adding the Place entity to the model.

extension Trip {
    
    static var viewContext: NSManagedObjectContext {
            return CoreDataManager.shared.viewContext
        }
    
    // The next step (for every function) is to call this function from inside the filter view. For now it is contained in the model.
    
    static func filterTripsByName(name: String) -> [Trip] {
        
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        request.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Trip.name), name)
        // [cd]:
        //  c = "case-insensitive"
        //  d = "diacritic-insensitive" (Letter "é" will be included in search for "e.")
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
    
    static func filterTripsStartingAfterDate(date: Date) -> [Trip] {
        
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        request.predicate = NSPredicate(format: "%K >= %@", #keyPath(Trip.startDate), date as NSDate)
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    static func filterTripsByDateRange(lower: Date, upper: Date) -> [Trip] {
        
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        // Predicates will be checked in order. So it will check the keypath (the trip's start date) to see if it's greater than or equal to the lower date bound and then check to see if it's less than or equal to the upper date bound.
        request.predicate = NSPredicate(format: "%K >= %@ AND %K <= %@",
                                        #keyPath(Trip.startDate), lower as NSDate,
                                        #keyPath(Trip.startDate), upper as NSDate)
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
}
