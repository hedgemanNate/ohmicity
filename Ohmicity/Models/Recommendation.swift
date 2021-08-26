//
//  Recommendation.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/24/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Recommendation: Codable {
    var recommendationID = UUID()
    let user: String
    let businessName: String
    let explanation: String
}
