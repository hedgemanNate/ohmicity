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
        var showCount = 0
        db.order(by: "lastModified", descending: true).whereField("lastModified", isGreaterThan: timeController.savedDateForDatabaseUse!).getDocuments() { (querySnapshot, error) in
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
                            //NSLog(show.venue," SHOW: RECEIVED & APPENDED")
                            showCount += 1
                        } else {
                            NSLog("Show data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding show: \(error)")
                    }
                }
                notificationCenter.post(notifications.gotShowData)
                NSLog("*****gotShowData DATA HIT*****")
            }
        }
        let temp = showArray.removingDuplicates()
        showArray = temp
        showArray.removeAll(where: {$0.onHold == true})
    }
    
    
    func getAllShowData() {
        var showCount = 0
        db.getDocuments { querySnapshot, error in
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
                            self.showArray.append(show)
                            showCount += 1
                            //NSLog(show.venue," SHOW: RECIEVED & APPENDED")
                        } else {
                            NSLog("Show data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding show: \(error)")
                    }
                }
                notificationCenter.post(notifications.gotAllShowData)
                NSLog("*****gotAllShowData DATA HIT*****")
            }
        }
        let temp = showArray.removingDuplicates()
        showArray = temp
        showArray.removeAll(where: {$0.onHold == true})
    }
    
    func fillArrayFromCache() {
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
                            self.showArray.append(show)
                            //NSLog("\(show.venue) SHOW: FILLING LOCAL ARRAY")
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
