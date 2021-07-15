//
//  BandController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/9/21.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

class BandController {
    //Properties
    var bandArray: [Band] = [] {
        didSet {
            
        }
    }
    
    let db = Firestore.firestore()
                      .collection("remoteData")
                      .document("remoteData")
                      .collection("bandData")
    
    
    //Functions
    
    func getNewBandData() {
        db.order(by: "lastModified", descending: true).whereField("lastModified", isGreaterThan: lmDateHandler.savedDate!).getDocuments() { (querySnapshot, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
//                for band in querySnapshot!.documents {
//                    let result = Result {
//                        try band.data(as: Band.self)
//                    }
//                    switch result {
//                    case .success(let band):
//                        if let band = band {
//                            self.bandArray.append(band)
//                            NSLog(band.name," SHOW: RECIEVED & APPENDED")
//                        } else {
//                            NSLog("Band data was nil")
//                        }
//                    case .failure(let error):
//                        NSLog("Error decoding band: \(error)")
//                    }
//                }
//                notificationCenter.post(notifications.gotBandData)
            }
        }
    }
    
    
    func getAllBandData() {
        db.getDocuments { querySnapshot, error in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                for band in querySnapshot!.documents {
                    let result = Result {
                        try band.data(as: Band.self)
                    }
                    switch result {
                    case .success(let band):
                        if let band = band {
                            self.bandArray.append(band)
                            NSLog(band.name," SHOW: RECIEVED & APPENDED")
                        } else {
                            NSLog("Band data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding band: \(error)")
                    }
                }
                notificationCenter.post(notifications.gotBandData)
            }
        }
    }
    
    func fillArray() {
            db.getDocuments(source: .cache) { querySnapshot, error in
                if let error = error {
                    NSLog(error.localizedDescription)
                } else {
                    for band in querySnapshot!.documents {
                        let result = Result {
                            try band.data(as: Band.self)
                        }
                        switch result {
                        case .success(let band):
                            if let band = band {
                                self.bandArray.append(band)
                                NSLog(band.name,"FILLING LOCAL ARRAY")
                            } else {
                                NSLog("Business data was nil")
                            }
                        case .failure(let error):
                            NSLog("Error decoding Business: \(error)")
                        }
                    }
                    notificationCenter.post(notifications.gotCacheBandData)
                }
            }
        }
}

let bandController = BandController()
