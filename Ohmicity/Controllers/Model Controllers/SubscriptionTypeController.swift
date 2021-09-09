//
//  SubscriptionController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/9/21.
//

import Foundation
import UIKit


class SubscriptionTypeController {
    //Properties
    var inAppPurchaseArray: [Subscription] = []
    
    //Icons
    let noAdsIcon = UIImage(named: "noAds.jpg")
    let unlimitedFavsIcon = UIImage(named: "unltdFavs.jpg")
    
    //Descriptions
    let frpDescription = ""
    let bspDescription = ""
    let fapDescription = ""
    
    func setUpInAppPurchaseArray() {
        guard let noAdsIcon = noAdsIcon else {return}
        guard let unlimitedFavsIcon = unlimitedFavsIcon else {return}
        let frpPurchase = Subscription(type: .FrontRowPass, description: frpDescription, icons: [noAdsIcon, unlimitedFavsIcon], price: "$1.99")
        
        
        
        inAppPurchaseArray.append(frpPurchase)
    }
    
}
