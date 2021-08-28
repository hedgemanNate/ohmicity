//
//  BannerAdController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/27/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class BusinessBannerAdController {
    
    //Properties
    var businessAdArray = [BusinessBannerAd]()
    
    let db = Firestore.firestore()
                          .collection("remoteData")
                          .document("remoteData")
                          .collection("businessBannerAdData")
}


//MARK: Functions
extension BusinessBannerAdController {
    
    func removeNonPublished() {
        businessAdArray.removeAll(where: {$0.isPublished == false})
    }
    
    func getAllBusinessAdData() {
        var businessAdCount = 0
        db.getDocuments { (querySnapshot, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                for businessAd in querySnapshot!.documents {
                    let result = Result {
                        try businessAd.data(as: BusinessBannerAd.self)
                    }
                    switch result {
                    case .success(let businessAd):
                        if let businessAd = businessAd {
                            self.businessAdArray.removeAll(where: {$0 == businessAd})
                            self.businessAdArray.append(businessAd)
                            
                            businessAdCount += 1
                        } else {
                            NSLog("Show data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding businessAd: \(error)")
                    }
                }
                notificationCenter.post(notifications.gotAllBusinessAdData)
                NSLog("*****gotAllBusinessAdData DATA HIT*****")
            }
        }
        businessAdArray.removeAll(where: {$0.isPublished == false})
    }
    
    func getNewBusinessAdData() {
        var businessAdCount = 0
        db.order(by: "lastModified", descending: true).whereField("lastModified", isGreaterThan: lmDateHandler.savedDate!).getDocuments() { (querySnapshot, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                for businessAd in querySnapshot!.documents {
                    let result = Result {
                        try businessAd.data(as: BusinessBannerAd.self)
                    }
                    switch result {
                    case .success(let businessAd):
                        if let businessAd = businessAd {
                            self.businessAdArray.removeAll(where: {$0 == businessAd})
                            self.businessAdArray.append(businessAd)
                            //NSLog(show.venue," SHOW: RECEIVED & APPENDED")
                            businessAdCount += 1
                        } else {
                            NSLog("Show data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding businessAd: \(error)")
                    }
                }
                notificationCenter.post(notifications.gotBusinessAdData)
                NSLog("*****gotBusinessAdData DATA HIT*****")
            }
        }
        businessAdArray.removeAll(where: {$0.isPublished == false})
    }
    
    
    func fillArrayFromCache() {
        db.getDocuments(source: .cache) { (querySnapshot, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                for businessAd in querySnapshot!.documents {
                    let result = Result {
                        try businessAd.data(as: BusinessBannerAd.self)
                    }
                    switch result {
                    case .success(let businessAd):
                        if let businessAd = businessAd {
                            self.businessAdArray.removeAll(where: {$0 == businessAd})
                            self.businessAdArray.append(businessAd)
                        } else {
                            NSLog("Show data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding businessAd: \(error)")
                    }
                }
                notificationCenter.post(notifications.bannerAdsLoaded)
                NSLog("*****bannerAdsLoaded HIT*****")
            }
        }
    }
}

let businessBannerAdController = BusinessBannerAdController()
