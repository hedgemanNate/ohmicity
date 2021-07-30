//
//  CurrentUser.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 5/10/21.
//

import Foundation
import Firebase

enum AccountType: String, Codable, Equatable {
    case Consumer
    case Artist
    case Business
}

struct CurrentUser: Codable {
    var userID: String
    var lastModified = Timestamp()
    var subscriber: Bool
    var bandFavorites: [String]
    var businessFavorites: [String]
    var accountType: AccountType
    var usedPromos: [String]
    var email: String
    var adPoints: Int
    
    init(userID: String, email: String) {
        self.userID = userID
        self.bandFavorites = []
        self.businessFavorites = []
        self.subscriber = false
        self.accountType = .Consumer
        self.usedPromos = []
        self.email = email
        self.adPoints = 0
    }
}

var currentUser: CurrentUser?
