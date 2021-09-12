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
    
    //Features
    let noAdsFeature = Feature(image: UIImage(named: "noAds.jpg") ?? UIImage(), name: "No Ads")
    let unlimitedFavsFeature = Feature(image: UIImage(named: "unltdFavs.jpg") ?? UIImage(), name: "Unlimited Favorites")
    
    //Descriptions
    let frpDescription = "No more Popup Ads and save as many Bands and Venues as you like!"
    let bspDescription = ""
    let fapDescription = ""
    
    func setUpInAppPurchaseArray() {
        let frpPurchase = Subscription(type: .FrontRowPass, description: frpDescription, features: [noAdsFeature, unlimitedFavsFeature], price: "$1.99")
        
        
        
        inAppPurchaseArray.append(frpPurchase)
    }
    
}

let subscriptionTypeController = SubscriptionTypeController()
