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
        db.order(by: "lastModified", descending: true).whereField("lastModified", isGreaterThan: timeController.savedDateForDatabaseUse!).getDocuments() { (querySnapshot, error) in
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
                            //NSLog(band.name," NEW SHOW: RECIEVED & APPENDED")
                        } else {
                            NSLog("Band data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding band: \(error)")
                    }
                }
                notificationCenter.post(notifications.gotNewBandData)
                NSLog("*****gotBandData DATA HIT*****")
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
                            //NSLog(band.name," SHOW: RECIEVED & APPENDED")
                        } else {
                            NSLog("Band data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding band: \(error)")
                    }
                }
                notificationCenter.post(notifications.gotAllBandData)
                NSLog("*****gotAllBandData DATA HIT*****")
            }
        }
    }
    
    func fillArrayFromCache() {
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
                                //NSLog(band.name,"FILLING LOCAL ARRAY")
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
