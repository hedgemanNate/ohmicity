//
//  UserAdController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/26/21.
//

import Foundation
import GoogleMobileAds

enum UserFeatureReply {
    case showLogin
    case showSubscriptions
    case allow
    case allowLimited
}

class UserAdController {
    //Properties
    var showAds = true
    
    //Google Ad Properties
    private var interstitialAd: GADInterstitialAd?
    var interstitialAdUnitID = "ca-app-pub-9052204067761521/5346686403"
    var interstitialTestAdID = "ca-app-pub-3940256099942544/4411468910"
    
    //Functions
    func setUpAdsAndFeaturesForUser() {
        if currentUserController.currentUser == nil {
            subscriptionController.favorites = false
            subscriptionController.noPopupAds = false
            subscriptionController.seeAllData = false
            subscriptionController.showReminders = false
            subscriptionController.todayShowFilter = false
            subscriptionController.search = false
            subscriptionController.xityDeals = false
        }
        
        guard let user = currentUserController.currentUser else {showAds = true; return}
        if user.subscription == .None {
            showAds = true
        } else {
            showAds = false
        }
        
        switch user.subscription {
        case .None:
            subscriptionController.favorites = false
            subscriptionController.noPopupAds = false
            subscriptionController.seeAllData = false
            subscriptionController.showReminders = false
            subscriptionController.todayShowFilter = false
            subscriptionController.search = false
            subscriptionController.xityDeals = false
        case .FrontRowPass:
            subscriptionController.favorites = true
            subscriptionController.noPopupAds = true
            subscriptionController.seeAllData = true
            subscriptionController.xityDeals = false
            subscriptionController.showReminders = false
            subscriptionController.todayShowFilter = false
            subscriptionController.search = false
        case .BackStagePass:
            subscriptionController.favorites = true
            subscriptionController.noPopupAds = true
            subscriptionController.seeAllData = true
            subscriptionController.showReminders = true
            subscriptionController.todayShowFilter = true
            subscriptionController.search = true
            subscriptionController.xityDeals = false
        case .FullAccessPass:
            subscriptionController.favorites = true
            subscriptionController.noPopupAds = true
            subscriptionController.seeAllData = true
            subscriptionController.showReminders = true
            subscriptionController.todayShowFilter = true
            subscriptionController.search = true
            subscriptionController.xityDeals = true
        }
    }
    
    func shouldShowAd() -> Bool {
        let x = Int.random(in: 1...10)
        if x <= 5 {
            return true
        } else {
            return false
        }
    }
}

let userAdController = UserAdController()


