//
//  RatingsController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/27/21.
//

import Foundation
import FirebaseFirestore

class RatingsController {
    
    //Properties
    var bandRatingArray = [BandsRatings]()
    
    
    func pushBandRatings() {
        if bandRatingArray != [] {
            for rating in bandRatingArray {
                do {
                    try FireStoreReferenceManager.bandsRatingsDataPath.document(rating.bandsRatingsID).setData(from: rating)
                    NSLog("✅ Band Ratings Pushed")
                } catch (let error) {
                    NSLog("🚨 \(error.localizedDescription)")
                }
                
            }
        }
    }
    
}

let ratingsController = RatingsController()
