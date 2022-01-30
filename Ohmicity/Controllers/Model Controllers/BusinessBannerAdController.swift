//
//  BannerAdController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/27/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class BusinessBannerAdController {
    
    //Properties
    static var businessAdArray = [BusinessBannerAd]()

    
}


//MARK: Functions
extension BusinessBannerAdController {
    
    static func removeNonPublished() {
        businessAdArray.removeAll(where: {$0.isPublished == false})
        businessAdArray.removeAll(where: {$0.endDate <= Date()})
    }
}
