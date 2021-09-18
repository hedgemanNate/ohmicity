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
    var shouldShowAds = true
    
    //Google Ad Properties
    private var interstitialAd: GADInterstitialAd?
    var interstitialAdUnitID = "ca-app-pub-9052204067761521/5346686403"
    var interstitialTestAdID = "ca-app-pub-3940256099942544/4411468910"
    
    //Functions
    func setUpAdsForUser() {
        guard let user = currentUserController.currentUser else {shouldShowAds = true; return}
        if user.subscription == .None {
            shouldShowAds = true
        } else {
            shouldShowAds = false
        }
    }
    
    func userFeaturesAvailableCheck(feature: Features) -> UserFeatureReply {
        var reply: UserFeatureReply = .showSubscriptions
        
        guard let currentUser = currentUserController.currentUser else {reply = .showLogin; return reply}
        
        //For Old Users: Until user.features is made non-optional-------
        if currentUser.features == nil {
            currentUser.features = []
        }
        // ---------------------
        
        if currentUser.features!.contains(feature) {
            reply = .allow
        } else {
            switch feature {
            case .Favorites:
                if currentUser.subscription == .None {
                    reply = .allowLimited
                }
            case .NoPopupAds:
                if currentUser.subscription != .None {
                    reply = .allow
                } else {
                    reply = .showSubscriptions
                }
            }
            
        }
        
        
        
        return reply
    }
}

let userAdController = UserAdController()
