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
    var businessArray: [BusinessFullData] = [] {
        didSet {
            
        }
    }
    
    let db = Firestore.firestore()
                      .collection("remoteData")
                      .document("remoteData")
                      .collection("businessFullData")
    
    
    //Functions
    
    func getNewBusinessData() {
        db.order(by: "lastModified", descending: true).whereField("lastModified", isGreaterThan: lmDateHandler.savedDate!).getDocuments() { (querySnapshot, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                NSLog("Business Data Cached")
//                for business in querySnapshot!.documents {
//                    let result = Result {
//                        try business.data(as: BusinessFullData.self)
//                    }
//                    switch result {
//                    case .success(let business):
//                        if let business = business {
//                            self.businessArray.append(business)
//                            NSLog(business.name!,"RECIEVED & APPENDED")
//                        } else {
//                            NSLog("Business data was nil")
//                        }
//                    case .failure(let error):
//                        NSLog("Error decoding Business: \(error)")
//                    }
//                }
                //notificationCenter.post(notifications.gotBusinessData)
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
                        try business.data(as: BusinessFullData.self)
                    }
                    switch result {
                    case .success(let business):
                        if let business = business {
                            self.businessArray.append(business)
                            NSLog(business.name!,"RECIEVED & APPENDED")
                        } else {
                            NSLog("Business data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding Business: \(error)")
                    }
                }
                notificationCenter.post(notifications.gotBusinessData)
            }
        }
    }
    
    func fillArray() {
        db.getDocuments(source: .cache) { querySnapshot, error in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                for business in querySnapshot!.documents {
                    let result = Result {
                        try business.data(as: BusinessFullData.self)
                    }
                    switch result {
                    case .success(let business):
                        if let business = business {
                            self.businessArray.append(business)
                            NSLog(business.name!,"RECIEVED & APPENDED")
                        } else {
                            NSLog("Business data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding Business: \(error)")
                    }
                }
                notificationCenter.post(notifications.gotCacheBusinessData)
            }
        }
    }
}

let businessController = BusinessController()
