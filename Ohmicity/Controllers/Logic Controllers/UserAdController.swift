//
//  UserAdController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/26/21.
//

import Foundation
import GoogleMobileAds

class UserAdController {
    var shouldShowAds = false
    
    //Google Ad Properties
    private var interstitialAd: GADInterstitialAd?
    var interstitialAdUnitID = "ca-app-pub-9052204067761521/5346686403"
    var interstitialTestAdID = "ca-app-pub-3940256099942544/4411468910"
    
    //Functions
    func setUpAdsForUser() {
        guard let user = currentUserController.currentUser else {return}
        if user.subscriber == true {
            shouldShowAds = false
        }
    }
}

let userAdController = UserAdController()
