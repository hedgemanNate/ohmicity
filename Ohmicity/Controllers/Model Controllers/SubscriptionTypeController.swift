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
    let ratingFeature = Feature(image: UIImage(named: "rate.jpg") ?? UIImage(), name: "Rate Bands and Venues")
    let remindersFeature = Feature(image: UIImage(named: "reminders.jpg") ?? UIImage(), name: "Never Miss a Show")
                
    //Descriptions
    let frpDescription = "No more popup ads and save as many bands and venues as you like!"
    let bspDescription = "Front Row Pass plus reminders for shows you pick and filter shows by the city!"
    let fapDescription = ""
    
    func setUpInAppPurchaseArray() {
        let frpPurchase = Subscription(type: .FrontRowPass, description: frpDescription, features: [noAdsFeature, unlimitedFavsFeature], price: "$1.99")
        inAppPurchaseArray.append(frpPurchase)
        
        let bspPurchase = Subscription(type: .BackStagePass, description: bspDescription, features: [ratingFeature, remindersFeature], price: "$4.99")
        inAppPurchaseArray.append(bspPurchase)
        
        
    }
    
}

let subscriptionTypeController = SubscriptionTypeController()
