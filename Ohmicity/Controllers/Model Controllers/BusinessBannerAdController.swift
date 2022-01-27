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
        businessAdArray.removeAll(where: {$0.endDate <= Date()})
    }
    
    
    
    func getAllBusinessAdData() {
        db.getDocuments { [self] (_, error) in
            if let error = error {
                NSLog(error.localizedDescription)
                //what to do if theres not internet connection
            } else {
                notificationCenter.post(notifications.gotAllBusinessAdData)
                fillBusinessAdArrayFromCache()
            }
        }
    }
    
    func getNewBusinessAdData() {
        db.order(by: "lastModified", descending: true).whereField("lastModified", isGreaterThan: timeController.savedDateForDatabaseUse!).getDocuments() { [self] (_, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                notificationCenter.post(notifications.gotNewBusinessAdData)
                fillBusinessAdArrayFromCache()
            }
        }
    }
    
    
    func fillBusinessAdArrayFromCache() {
        db.getDocuments() { [self] (querySnapshot, error) in
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
                removeNonPublished()
            }
        }
    }
}

let businessBannerAdController = BusinessBannerAdController()
