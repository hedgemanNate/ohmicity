//
//  UserAdController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/26/21.
//

import Foundation
import GoogleMobileAds

enum GoogleAdID: String {
    case paidAdUnitID = "ca-app-pub-9052204067761521/4962469563"
    case testAdUnitID = "ca-app-pub-3940256099942544/4411468910"
}

class UserAdController {
    //Properties
    var percentArray = RemoteControllerModel.adPercentArray
    
    var userSubscription = SubscriptionType.None {
        didSet {
            currentUserController.setUpCurrentUserPreferences()
            NotifyCenter.post(Notifications.userAuthUpdated)
        }
    }
    
    //Google Ad Properties
    private var interstitialAd: GADInterstitialAd?
    var activePopUpAdUnitID = GoogleAdID.paidAdUnitID.rawValue
    
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
        
        //guard let user = currentUserController.currentUser else {subscriptionController.noPopupAds = false; return}
        
        switch userSubscription {
        case .None:
            //Changed for free usage
            subscriptionController.favorites = true
            subscriptionController.noPopupAds = false
            subscriptionController.seeAllData = true
            subscriptionController.showReminders = true
            subscriptionController.todayShowFilter = true
            subscriptionController.search = true
            subscriptionController.xityDeals = true
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
            subscriptionController.xityDeals = true
        case .FullAccessPass:
            subscriptionController.favorites = true
            subscriptionController.noPopupAds = true
            subscriptionController.seeAllData = true
            subscriptionController.showReminders = true
            subscriptionController.todayShowFilter = true
            subscriptionController.search = true
            subscriptionController.xityDeals = true
        case .err:
            break
        }
    }
    
    func shouldShowAd() -> Bool {
        if DevelopmentSettingsController.devSettings.ads == false {percentArray = [0]}
        let x = Int.random(in: 1...10)
        if percentArray.contains(x) {
            return true
        } else {
            return false
        }
    }
}

let userAdController = UserAdController()


