//
//  LoginViewModel.swift
//  ItineraryMap
//
//  Created by Elise on 6/18/23.
//

import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var username = ""
    @Published var password = ""
    @Published var isSignedIn = false
    @Published var submissionIsEmpty = false
    @Published var userIsNotFound = false
    @Published var passwordIsIncorrect = false
    var userVM: UserViewModel?
    
    func signIn(username: String, password: String) {
        
        let userArray = Validation.findUserByUsername(username: username)
        guard !userArray.isEmpty else {
            userIsNotFound = true
            return
        }
        
        guard let userVM = userArray.first else { return }
        print("*** ----- User: \(userVM.username) -------- ***")
              
        guard password == userVM.password else {
            passwordIsIncorrect = true
            return
        }
        
        self.userVM = userVM
        self.isSignedIn = true
    }
    
    func signOut() {
        self.isSignedIn = false
    }
}
