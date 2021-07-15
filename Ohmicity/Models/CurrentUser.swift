//
//  CurrentUser.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 5/10/21.
//

import Foundation
import Firebase



struct CurrentUser {
    var userID: String
    var level: Int
    var favorites: [String]
    var accountType: String
    var usedPromos: [String]
    var email: String
    
    init(userID: String, email: String) {
        self.userID = userID
        self.favorites = []
        self.level = 0
        self.accountType = "customer"
        self.usedPromos = []
        self.email = email
    }
}

var currentUser: CurrentUser?
