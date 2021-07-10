//
//  ShowController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/9/21.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

class ShowController {
    //Properties
    var showArray: [Show] = []
    let db = Firestore.firestore()
                      .collection("remoteData")
                      .document("remoteData")
                      .collection("showData")
    
    
    //Functions
    
    func getNewShowData(completion: @escaping (DataResults) -> Void) {
        db.order(by: "lastModified", descending: true).whereField("lastModified", isGreaterThan: lmDateHandler.savedDate!).getDocuments() { (querySnapshot, error) in
            if let error = error {
                NSLog(error.localizedDescription)
                completion(.failure)
            } else {
                for show in querySnapshot!.documents {
                    let result = Result {
                        try show.data(as: Show.self)
                    }
                    switch result {
                    case .success(let show):
                        if let show = show {
                            self.showArray.append(show)
                        } else {
                            NSLog("Show data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding show: \(error)")
                    }
                    completion(.success)
                }
            }
        }
    }
    
    
    func getAllShowData(completion: @escaping (DataResults) -> Void) {
        db.getDocuments { querySnapshot, error in
            if let error = error {
                NSLog(error.localizedDescription)
                completion(.failure)
            } else {
                for show in querySnapshot!.documents {
                    let result = Result {
                        try show.data(as: Show.self)
                    }
                    switch result {
                    case .success(let show):
                        if let show = show {
                            self.showArray.append(show)
                        } else {
                            NSLog("Show data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding show: \(error)")
                    }
                    completion(.success)
                }
            }
        }
    }
}

let showController = ShowController()
