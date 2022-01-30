//
//  BusinessController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/8/21.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

class BusinessController {
    //Properties
    static var businessArray: [Business] = [] {
        didSet {
            
        }
    }
    
    static let citiesArray: [City] = [.Venice, .Sarasota, .Bradenton, .StPete, .Tampa, .Ybor]
    static let businessTypeArray: [BusinessType] = [.Bar, .Club, .LiveMusic, .Restaurant, .Outdoors, .Family]
    
    //Functions
    
    static func getAllBusinessData() async throws {
        let snap = try await FireStoreReferenceManager.venueDataPath.getDocuments()
        
        BusinessController.businessArray = snap.documents.compactMap({ venues in
            try? venues.data(as: Business.self)
        })
    }
    
}
let businessController = BusinessController()
