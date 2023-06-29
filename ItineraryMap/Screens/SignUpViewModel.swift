//
//  SignUpViewModel.swift
//  ItineraryMap
//
//  Created by Elise on 6/18/23.
//

import Foundation

@MainActor
class SignUpViewModel: Hashable, ObservableObject {
    
    var id = UUID()
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var submissionIsEmpty = false
    @Published var isExistingUser = false
    
    func isDuplicateUser(username: String, password: String) -> Bool {
        let userArray = Validation.findUserByUsername(username: username)
        if userArray.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func createUser() -> Bool {
        
        if isDuplicateUser(username: username, password: password) {
            isExistingUser = true
            return false
        }
        
        let manager = CoreDataManager.shared
        
        // User class is automatically generated based on the model file.
        let user = User(context: manager.persistentContainer.viewContext)
        
        user.username = username
        user.password = password
        
        // Persists the data.
        // Need to implement this function in Core Data Manager class.
        manager.save()
        return true
    }
    
    // Need these to use Navigation Stack
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: SignUpViewModel, rhs: SignUpViewModel) -> Bool {
        return (lhs.id == rhs.id)
    }
}
