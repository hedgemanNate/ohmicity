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
    var bandArray: [Band] = [] { didSet { /*function here*/  }}
    let genreTypeArray: [Genre] = [.Blues, .Country, .DJ, .Dance, .EDM, .EasyListening, .Experimental, .FunkSoul, .Gospel, .HipHop, .JamBand, .Jazz, .Metal, .Pop, .Reggae, .Rock]
        
    let db = Firestore.firestore()
                      .collection("remoteData")
                      .document("remoteData")
                      .collection("bandData")
    
    
    //Functions
    
    func getNewBandData() {
        db.order(by: "lastModified", descending: true).whereField("lastModified", isGreaterThan: timeController.savedDateForDatabaseUse!).getDocuments() { [self] (_, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                notificationCenter.post(notifications.gotNewBandData)
                fillBandArrayFromCache()
            }
        }
    }
    
    
    func getAllBandData() {
        db.getDocuments { [self] (_, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                notificationCenter.post(notifications.gotAllBandData)
                fillBandArrayFromCache()
            }
        }
    }
    
    func fillBandArrayFromCache() {
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
                                self.bandArray.removeAll(where: {$0 == band})
                                self.bandArray.append(band)
                            } else {
                                NSLog("Business data was nil")
                            }
                        case .failure(let error):
                            NSLog("Error decoding Business: \(error)")
                        }
                    }
                    notificationCenter.post(notifications.gotCacheBandData)
                    NSLog("*****gotCacheBandData HIT*****")
                }
            }
        }
}

let bandController = BandController()
