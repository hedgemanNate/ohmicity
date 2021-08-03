//
//  User.swift
//  Ohmicity Backend
//
//  Created by Nate Hedgeman on 6/2/21.
//

import Foundation
import FirebaseFirestore

struct User: Codable {
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
}

var currentUser: User?
