//
//  RecommendationController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/27/21.
//

import Foundation

class RecommendationController {
    //Properties
    var recommendArray = [Recommendation]()
    
    func pushRecommendations() {
        if recommendArray != [] {
            for reco in recommendArray {
                do {
                    try FireStoreReferenceManager.recommendationPath.document(reco.recommendationID).setData(from: reco)
                    NSLog("✅ Recommendation Pushed")
                } catch (let error) {
                    NSLog("🚨 \(error.localizedDescription)")
                }
            }
        }
    }
}

let recommendationController = RecommendationController()
