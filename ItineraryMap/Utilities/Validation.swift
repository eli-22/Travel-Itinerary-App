//
//  Validation.swift
//  ItineraryMap
//
//  Created by Elise on 6/18/23.
//

import Foundation

class Validation {
    
    static func findUserByUsername(username: String) -> [UserViewModel] {
        return User.findUserByUsername(username: username).map(UserViewModel.init)
    }
}
