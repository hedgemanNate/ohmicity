//
//  Reviews.swift
//  Ohmicity Backend
//
//  Created by Nathan Hedgeman on 7/9/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct BandsRatings: Codable {
    let bandsRatingsID: String
    var bandName: String
    let userID: String
    var stars: Int
    
    init(bandName: String, userID: String, stars: Int) {
        self.bandsRatingsID = UUID().uuidString
        self.bandName = bandName
        self.userID = userID
        self.stars = stars
    }
}


struct UsersRatings: Codable {
    var businessName: String?
    var bandName: String?
    var rating: Int
}

struct BusinessRatings: Codable {
    let businessRatingsID: String
    var businessName: String
    let userID: String
    var stars: Int
    
    init(businessName: String, userID: String, stars: Int) {
        self.businessRatingsID = UUID().uuidString
        self.businessName = businessName
        self.userID = userID
        self.stars = stars
    }
}
