//
//  RemoteController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 2/24/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class RemoteController {
    
    static var remoteModel: RemoteControllerModel? {
        didSet {
            NotifyCenter.post(Notifications.remoteControlUpdated)
        }
    }
    
    static func setRemoteControlListener() {
        FireStoreReferenceManager.remoteControlDataPath.document("remoteController").addSnapshotListener { snap, err in
            if let err = err {
                NSLog(err.localizedDescription)
            } else {
                guard let snap = snap else {return}
                do {
                    RemoteController.remoteModel = try snap.data(as: RemoteControllerModel.self)!
                } catch (let error) {
                    NSLog(error.localizedDescription)
                }
            }
        }
    }
}
