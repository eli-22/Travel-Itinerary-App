//
//  Place + Ext.swift
//  ItineraryMap
//
//  Created by Elise on 2/18/23.
//

import CoreData

// Create an extension because the Place class already exists. It was generated automatically adding the Place entity to the model.

extension Place {
    
    static func getPlacesByTripId(tripId: NSManagedObjectID) -> [Place] {
        
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        request.predicate = NSPredicate(format: "trip = %@", tripId)
        
        do {
            return try CoreDataManager.shared.viewContext.fetch(request)
        } catch {
            return []
        }
    }
}
