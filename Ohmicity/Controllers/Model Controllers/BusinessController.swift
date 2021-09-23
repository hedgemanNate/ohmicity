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
        db.order(by: "lastModified", descending: true).whereField("lastModified", isGreaterThan: timeController.savedDateForDatabaseUse!).getDocuments() { (querySnapshot, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                NSLog("Business Data Cached")
                for business in querySnapshot!.documents {
                    let result = Result {
                        try business.data(as: Business.self)
                    }
                    switch result {
                    case .success(let business):
                        if let business = business {
                            self.businessArray.removeAll(where: {$0 == business})
                            self.businessArray.append(business)
                            //NSLog(business.name,"RECIEVED & APPENDED")
                        } else {
                            NSLog("Business data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding Business: \(error)")
                    }
                }
                notificationCenter.post(notifications.gotNewBusinessData)
                NSLog("*****gotBusinessData DATA HIT*****")
            }
        }
    }

    
    
    func getAllBusinessData() {
        db.getDocuments { querySnapshot, error in
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
                            self.businessArray.append(business)
                            //NSLog(business.name,"RECIEVED & APPENDED")
                        } else {
                            NSLog("Business data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding Business: \(error)")
                    }
                }
                notificationCenter.post(notifications.gotAllBusinessData)
                NSLog("*****gotAllBusinessData DATA HIT*****")
            }
        }
    }
    
    func fillArrayFromCache() {
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
                            self.businessArray.append(business)
                            //NSLog(business.name,"RECIEVED & APPENDED")
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
