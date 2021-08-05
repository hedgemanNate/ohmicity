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

class CurrentUser: Codable {
    let userID: String
    var accountType: AccountType = .Consumer
    var lastModified: Timestamp?
    var email: String
    var savedShows: [String] = []
    var favoriteBusinesses: [String] = []
    var favoriteBands: [String] = []
    var usedPromotions: [String] = []
    var paidServices: [String] = []
    var subscriber: Bool = false
    var adPoints: Int = 0
    
    init(userID: String, email: String) {
        self.userID = userID
        self.email = email
    }
}


