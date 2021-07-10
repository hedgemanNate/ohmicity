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
    var businessArray: [BusinessFullData] = []
    let db = Firestore.firestore()
                      .collection("remoteData")
                      .document("remoteData")
                      .collection("businessFullData")
    
    
    //Functions
    
    func getNewBusinessData(completion: @escaping (DataResults) -> Void) {
        db.order(by: "lastModified", descending: true).whereField("lastModified", isGreaterThan: lmDateHandler.savedDate!).getDocuments() { (querySnapshot, error) in
            if let error = error {
                NSLog(error.localizedDescription)
                completion(.failure)
            } else {
                for business in querySnapshot!.documents {
                    let result = Result {
                        try business.data(as: BusinessFullData.self)
                    }
                    switch result {
                    case .success(let business):
                        if let business = business {
                            self.businessArray.append(business)
                        } else {
                            NSLog("Business data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding Business: \(error)")
                    }
                    completion(.success)
                }
            }
        }
    }
    
    
    func getAllBusinessData(completion: @escaping (DataResults) -> Void) {
        db.getDocuments { querySnapshot, error in
            if let error = error {
                NSLog(error.localizedDescription)
                completion(.failure)
            } else {
                for business in querySnapshot!.documents {
                    let result = Result {
                        try business.data(as: BusinessFullData.self)
                    }
                    switch result {
                    case .success(let business):
                        if let business = business {
                            self.businessArray.append(business)
                        } else {
                            NSLog("Business data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding Business: \(error)")
                    }
                    completion(.success)
                }
            }
        }
    }
}

let businessController = BusinessController()
