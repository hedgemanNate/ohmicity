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
    var bandGroupArray = [GroupOfProductionBands]()
    
    var bandArray: [Band] = [] { didSet { /*function here*/  }}
    let genreTypeArray: [Genre] = [.Blues, .Country, .DJ, .Dance, .EDM, .EasyListening, .Experimental, .FunkSoul, .Gospel, .HipHop, .JamBand, .Jazz, .Metal, .Pop, .Reggae, .Rock]
        
    let db = FireStoreReferenceManager.bandDataPath
    
    
    //Functions
    
//    func getNewBandData() {
//        guard let savedDate = timeController.savedDateForDatabaseUse else {return}
//        db.order(by: "lastModified", descending: true).whereField("lastModified", isGreaterThan: savedDate).getDocuments() { [self] (_, error) in
//            if let error = error {
//                NSLog(error.localizedDescription)
//            } else {
//                print("GETTING NEW BAND DATA: Time \(savedDate)")
//                notificationCenter.post(notifications.gotNewBandData)
//                fillBandArrayFromCache()
//            }
//        }
//    }
//
//
//    func getAllBandData() {
//        db.getDocuments { [self] (_, error) in
//            if let error = error {
//                NSLog(error.localizedDescription)
//            } else {
//                notificationCenter.post(notifications.gotAllBandData)
//                fillBandArrayFromCache()
//            }
//        }
//    }
    
    func getAllBandData() {
        FireStoreReferenceManager.bandDataPath.getDocuments { snapShot, error in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                for bandGroup in snapShot!.documents {
                    let result = Result {
                        try bandGroup.data(as: GroupOfProductionBands.self)
                    }
                    switch result {
                    case .success(let bandGroup):
                        if let bandGroup = bandGroup {
                            self.bandGroupArray.append(bandGroup)
                        } else {
                            NSLog("Band Group is nil")
                        }
                    case .failure(let error):
                        NSLog(error.localizedDescription)
                    }
                }
                notificationCenter.post(notifications.gotAllBandData)
                self.fillBandArrayFromCache()
            }
            
        }
        
    }
    
    func fillBandArrayFromCache() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            for bandGroup in self.bandGroupArray {
                for band in bandGroup.bands {
                    let newBand = Band(singleBand: band)
                    self.bandArray.append(newBand)
                }
            }
            notificationCenter.post(notifications.gotCacheBandData)
            NSLog("*****gotCacheBandData HIT*****")
        }
        
    }
    
    
//    func fillBandArrayFromCache() {
//            db.getDocuments(source: .cache) { querySnapshot, error in
//                if let error = error {
//                    NSLog(error.localizedDescription)
//                } else {
//                    for band in querySnapshot!.documents {
//                        let result = Result {
//                            try band.data(as: Band.self)
//                        }
//                        switch result {
//                        case .success(let band):
//                            if let band = band {
//                                if band.genre == [] {
//                                    band.genre = [.NA]
//                                }
//                                self.bandArray.removeAll(where: {$0 == band})
//                                self.bandArray.append(band)
//                            } else {
//                                NSLog("Business data was nil")
//                            }
//                        case .failure(let error):
//                            NSLog("Error decoding Business: \(error)")
//                        }
//                    }
//                    notificationCenter.post(notifications.gotCacheBandData)
//                    NSLog("*****gotCacheBandData HIT*****")
//                }
//            }
//        }
}

let bandController = BandController()
