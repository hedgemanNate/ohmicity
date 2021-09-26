//
//  CurrentUser.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 5/10/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum AccountType: String, Codable, Equatable {
    case Consumer
    case Artist
    case Business
}

class CurrentUser: Codable {
    let userID: String
    var accountType: AccountType = .Consumer
    var subscription: SubscriptionType = .None
    var lastModified: Timestamp?
    var email: String
    var savedShows: [String] = []
    var favoriteBusinesses: [String] = []
    var favoriteBands: [String] = []
    var bandRatings: [UsersRatings]?
    var usedPromotions: [String] = []
    var paidServices: [String] = []
    var features: [Features]?
    //var adPoints: Int = 0
    var preferredCity: City?
    var recommendationCount: Int?
    
    init(userID: String, email: String) {
        self.userID = userID
        self.email = email
        self.lastModified = Timestamp()
        self.bandRatings = []
        self.preferredCity = .All
        self.recommendationCount = 0
    }
}


