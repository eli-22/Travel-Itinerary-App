//
//  CoreDataManager.swift
//  ItineraryMap
//
//  Created by Elise on 2/5/23.
//

import Foundation
import CoreData
import SwiftUI


class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    
    // Create a shared instance, which will be used any time you want to access the Core Data Manger.
    static let shared = CoreDataManager()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    // Make the initializer private, so we have to use the instance created above.
    private init() {
        
        // Load persistent store, which by default is SQLite.
        // Model name must match the name of data model file.
        persistentContainer = NSPersistentContainer(name: "TripAppModel")
        
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to initialize Core Data: \(error)")
            }
        }
        
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print(directories[0])
    }
    
    // Save function will persist the data in the NSManagedObjectContext, the view context.
    func save() {
        do {
            try persistentContainer.viewContext.save()
            print("Successful save.")
        } catch {
            persistentContainer.viewContext.rollback() // Rollback changes if something doesn't work.
            print("Failed to save: \(error)")
        }
    }
    
    func displayAllTrips() -> [Trip] {
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func showTripsByUser(user: User) -> [Trip] {
        
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Trip.user), user)

        do {
            return try viewContext.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
    
    
    // We need this function to delete a trip.
    func findTripById(id: NSManagedObjectID) -> Trip? {
        do {
            return try persistentContainer.viewContext.existingObject(with: id) as? Trip
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteTrip (trip: Trip) {
        persistentContainer.viewContext.delete(trip)
        // This doesn't actually delete the trip immediately. It marks it for deletion in the NSManagedObjectContext.
        // Still need to persist the Managed Object Context.
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print ("Failed to delete trip. \(error)")
        }
    }
    
    // Need this function to delete a place from a trip.
    func findPlaceById(id: NSManagedObjectID) -> Place? {
        do {
            return try persistentContainer.viewContext.existingObject(with: id) as? Place
        } catch {
            print(error)
            return nil
        }
    }
  
    func deletePlace (place: Place) {
        persistentContainer.viewContext.delete(place)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print ("Failed to delete place. \(error)")
        }
    }
}
