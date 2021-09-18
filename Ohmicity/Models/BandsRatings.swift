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
    var ratingID: String
    let userID: String
    var stars: Int
    
    init(userID: String, stars: Int) {
        self.ratingID = UUID().uuidString
        self.userID = userID
        self.stars = stars
    }
}


struct UserRatings: Codable {
    var bandName: String
    var rating: Int
}
