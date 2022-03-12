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
    static var inAppPurchaseArray: [Subscription] = []
    
    //Features Enabled
    static var favorites = true
    static var noPopupAds = false
    static var seeAllData = true
    static var xityDeals = true
    static var showReminders = true
    static var todayShowFilter = true
    static var search = true
    
    
    //Features
    static let noAdsFeature = PaywallFeature(image: UIImage(named: "NoAds.png") ?? UIImage(), name: "Remove Popup Ads")
    static let unlimitedFavsFeature = PaywallFeature(image: UIImage(named: "unltdFavs.jpg") ?? UIImage(), name: "Unlimited Favorites")
    static let memberAccess = PaywallFeature(image: UIImage(named: "members.png") ?? UIImage(), name: "Members Area Access")
    static let searchFeature = PaywallFeature(image: UIImage(named: "search.jpg") ?? UIImage(), name: "Search For Bands")
    static let remindersFeature = PaywallFeature(image: UIImage(named: "reminders.jpg") ?? UIImage(), name: "Never Miss a Show")
                
    //Descriptions
    static let frpDescription = "No more popup ads, get access to the Members Area with 4X more shows*"
    static let bspDescription = "Front Row Pass plus save future shows, search for bands and venues and more!*"
    static let fapDescription = ""
    
    static func setUpInAppPurchaseArray() {
        let frpPurchase = Subscription(type: .FrontRowPass, description: frpDescription, features: [noAdsFeature, memberAccess], price: "$2.99")
        inAppPurchaseArray.append(frpPurchase)
        
        let bspPurchase = Subscription(type: .BackStagePass, description: bspDescription, features: [searchFeature, remindersFeature], price: "$4.99")
        inAppPurchaseArray.append(bspPurchase)
    }
    
    static func userFeaturesAvailableCheck(feature: Bool, viewController: UIViewController, completion: ()->()) {
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
