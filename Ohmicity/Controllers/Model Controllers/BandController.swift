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
    var bandArray: [Band] = []
    let db = Firestore.firestore()
                      .collection("remoteData")
                      .document("remoteData")
                      .collection("bandData")
    
    
    //Functions
    
    func getNewBandData(completion: @escaping (DataResults) -> Void) {
        db.order(by: "lastModified", descending: true).whereField("lastModified", isGreaterThan: lmDateHandler.savedDate!).getDocuments() { (querySnapshot, error) in
            if let error = error {
                NSLog(error.localizedDescription)
                completion(.failure)
            } else {
                for band in querySnapshot!.documents {
                    let result = Result {
                        try band.data(as: Band.self)
                    }
                    switch result {
                    case .success(let band):
                        if let band = band {
                            self.bandArray.append(band)
                        } else {
                            NSLog("Band data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding band: \(error)")
                    }
                    completion(.success)
                }
            }
        }
    }
    
    
    func getAllBandData(completion: @escaping (DataResults) -> Void) {
        db.getDocuments { querySnapshot, error in
            if let error = error {
                NSLog(error.localizedDescription)
                completion(.failure)
            } else {
                for band in querySnapshot!.documents {
                    let result = Result {
                        try band.data(as: Band.self)
                    }
                    switch result {
                    case .success(let band):
                        if let band = band {
                            self.bandArray.append(band)
                        } else {
                            NSLog("Band data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding band: \(error)")
                    }
                    completion(.success)
                }
            }
        }
    }
}

let bandController = BandController()
