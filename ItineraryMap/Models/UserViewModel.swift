//
//  UserViewModel.swift
//  ItineraryMap
//
//  Created by Elise on 6/18/23.
//

import Foundation

struct UserViewModel {
    
    let user: User

    var username: String {
        return user.username ?? ""
    }

    var password: String {
        return user.password ?? ""
    }
}

