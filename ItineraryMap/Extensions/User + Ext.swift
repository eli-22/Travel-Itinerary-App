//
//  User + Ext.swift
//  ItineraryMap
//
//  Created by Elise on 6/18/23.
//

import CoreData

extension User {

    static var viewContext: NSManagedObjectContext {
            return CoreDataManager.shared.viewContext
        }
    
    // The next step is to call this function from inside the login view. For now it is contained in the model.
    static func findUserByUsername(username: String) -> [User] {
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "%K ==[cd] %@", #keyPath(User.username), username)
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
}
