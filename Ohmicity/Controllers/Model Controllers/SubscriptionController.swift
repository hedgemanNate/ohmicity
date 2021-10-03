//
//  SubscriptionController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/9/21.
//

import Foundation
import UIKit


class SubscriptionController {
    //Properties
    var inAppPurchaseArray: [Subscription] = []
    
    //Features Enabled
    var favorites = false
    var noPopupAds = false
    var seeAllData = false
    var xityDeals = false
    var showReminders = false
    var todayShowFilter = false
    var search = false
    
    
    //Features
    let noAdsFeature = PaywallFeature(image: UIImage(named: "noAds.jpg") ?? UIImage(), name: "No Ads")
    let unlimitedFavsFeature = PaywallFeature(image: UIImage(named: "unltdFavs.jpg") ?? UIImage(), name: "Unlimited Favorites")
    let ratingFeature = PaywallFeature(image: UIImage(named: "rate.jpg") ?? UIImage(), name: "Rate Bands and Venues")
    let remindersFeature = PaywallFeature(image: UIImage(named: "reminders.jpg") ?? UIImage(), name: "Never Miss a Show")
                
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
    
    func userFeaturesAvailableCheck(feature: Bool, viewController: UIViewController, completion: ()->()) {
        if currentUserController.currentUser != nil {
            if feature {
                completion()
            } else {
                viewController.performSegue(withIdentifier: "ToPurchaseSegue", sender: viewController)
            }
        } else {
            viewController.performSegue(withIdentifier: "ToSignIn", sender: viewController)
        }
    }
    
}

let subscriptionController = SubscriptionController()
