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
    
    var todayShowArray = [Show]()
    var showArray: [Show] = [] {
        didSet {
            
        }
    }
    
    let db = Firestore.firestore()
                      .collection("remoteData")
                      .document("remoteData")
                      .collection("showData")
    
    
    //Functions
    func removeHolds() {
        showArray.removeAll(where: {$0.onHold == true})
    }
    
    func getNewShowData() {
        db.order(by: "lastModified", descending: true).whereField("lastModified", isGreaterThan: timeController.savedDateForDatabaseUse!).getDocuments() { [self] (_, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                notificationCenter.post(notifications.gotNewShowData)
                fillShowArrayFromCache()
            }
        }
        let temp = showArray.removingDuplicates()
        showArray = temp
        showArray.removeAll(where: {$0.onHold == true})
    }
    
    
    func getAllShowData() {
        db.getDocuments { [self] (_, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                notificationCenter.post(notifications.gotAllShowData)
                fillShowArrayFromCache()
            }
        }
        let temp = showArray.removingDuplicates()
        showArray = temp
        showArray.removeAll(where: {$0.onHold == true})
    }
    
    func fillShowArrayFromCache() {
        var showCount = 0
        db.getDocuments(source: .cache) { querySnapshot, error in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                for show in querySnapshot!.documents {
                    let result = Result {
                        try show.data(as: Show.self)
                    }
                    switch result {
                    case .success(let show):
                        if let show = show {
                            self.showArray.removeAll(where: {$0 == show})
                            self.showArray.append(show)
                            showCount += 1
                        } else {
                            NSLog("Business data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding Business: \(error)")
                    }
                }
                notificationCenter.post(notifications.gotCacheShowData)
                NSLog("*****gotCacheShowData HIT*****")
            }
        }
        let temp = showArray.removingDuplicates()
        showArray = temp
        showArray.removeAll(where: {$0.onHold == true})
    }
}

let showController = ShowController()
