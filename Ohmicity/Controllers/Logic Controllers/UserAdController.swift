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
            SubscriptionController.favorites = false
            SubscriptionController.noPopupAds = false
            SubscriptionController.seeAllData = false
            SubscriptionController.showReminders = false
            SubscriptionController.todayShowFilter = false
            SubscriptionController.search = false
            SubscriptionController.xityDeals = false
        }
        
        //guard let user = currentUserController.currentUser else {SubscriptionController.noPopupAds = false; return}
        
        switch userSubscription {
        case .None:
            //Changed for free usage
            SubscriptionController.favorites = true
            SubscriptionController.noPopupAds = false
            SubscriptionController.seeAllData = true
            SubscriptionController.showReminders = true
            SubscriptionController.todayShowFilter = true
            SubscriptionController.search = true
            SubscriptionController.xityDeals = true
        case .FrontRowPass:
            SubscriptionController.favorites = true
            SubscriptionController.noPopupAds = true
            SubscriptionController.seeAllData = true
            SubscriptionController.xityDeals = false
            SubscriptionController.showReminders = false
            SubscriptionController.todayShowFilter = false
            SubscriptionController.search = false
        case .BackStagePass:
            SubscriptionController.favorites = true
            SubscriptionController.noPopupAds = true
            SubscriptionController.seeAllData = true
            SubscriptionController.showReminders = true
            SubscriptionController.todayShowFilter = true
            SubscriptionController.search = true
            SubscriptionController.xityDeals = true
        case .FullAccessPass:
            SubscriptionController.favorites = true
            SubscriptionController.noPopupAds = true
            SubscriptionController.seeAllData = true
            SubscriptionController.showReminders = true
            SubscriptionController.todayShowFilter = true
            SubscriptionController.search = true
            SubscriptionController.xityDeals = true
        case .err:
            break
        }
    }
    
    func shouldShowAd() -> Bool {
        if DevelopmentSettingsController.devSettings.ads == false {RemoteController.remoteModel.adPercentArray = [0]}
        let x = Int.random(in: 1...10)
        if RemoteController.remoteModel.adPercentArray.contains(x) {
            return true
        } else {
            return false
        }
    }
}

let userAdController = UserAdController()


