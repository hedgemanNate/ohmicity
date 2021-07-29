//
//  BannerAdController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/27/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class BannerAdController {
    
    //Properties
    var bannerAdArray = [BannerAd]()
    
}


//MARK: Functions
extension BannerAdController {
    
    func fillArray() {
        
        guard let image = UIImage(named: "bannerAdExample1.png") else {return}
        let ad1 = BannerAd(_with: image, businessID: "Blue Rooster")
        bannerAdArray = [ad1, ad1, ad1 ,ad1]
        
        notificationCenter.post(name: notifications.bannerAdsLoaded.name, object:nil, userInfo: ["InitialLoadingScreen": LoadingScreenInfo.BannerAdsLoaded.rawValue])
        NSLog("*****FILL BANNER DATA ARRAY HIT*****")
    
        
    }
}

let bannerAdController = BannerAdController()
