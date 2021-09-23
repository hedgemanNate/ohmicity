//
//  BusinessController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/8/21.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

class BusinessController {
    //Properties
    var todayVenueArray = [Business]()
    var businessArray: [Business] = [] {
        didSet {
            
        }
    }
    
    let citiesArray: [City] = [.Venice, .Sarasota, .Bradenton, .StPete, .Tampa, .Ybor]
    let businessTypeArray: [BusinessType] = [.Bar, .Club, .LiveMusic, .Restaurant, .Outdoors, .Family]
    
    let db = Firestore.firestore()
                      .collection("remoteData")
                      .document("remoteData")
                      .collection("businessFullData")
    
    
    //Functions
    
    func getNewBusinessData() {
        db.order(by: "lastModified", descending: true).whereField("lastModified", isGreaterThan: timeController.savedDateForDatabaseUse!).getDocuments() { [self] (_, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                notificationCenter.post(notifications.gotNewBusinessData)
                fillBusinessArrayFromCache()
            }
        }
    }

    
    
    func getAllBusinessData() {
        db.getDocuments { [self] (_, error) in
            if let error = error {
                NSLog(error.localizedDescription)
                //what to do if theres not internet connection
            } else {
                notificationCenter.post(notifications.gotAllBusinessData)
                fillBusinessArrayFromCache()
            }
        }
    }
    
    func fillBusinessArrayFromCache() {
        db.getDocuments(source: .cache) { querySnapshot, error in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                for business in querySnapshot!.documents {
                    let result = Result {
                        try business.data(as: Business.self)
                    }
                    switch result {
                    case .success(let business):
                        if let business = business {
                            self.businessArray.removeAll(where: {$0 == business})
                            self.businessArray.append(business)
                        } else {
                            NSLog("Business data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding Business: \(error)")
                    }
                }
                notificationCenter.post(notifications.gotCacheBusinessData)
                NSLog("*****gotCacheBusinessData HIT*****")
            }
        }
    }
}

let businessController = BusinessController()
