//
//  XitySupportController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/17/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class XitySupportController {
    var xitySupportInstances = [XitySupport]()
     
    func pushXitySupport(xitySupport: XitySupport) {
        do {
            try ref.xitySupportDataPath.document(xitySupport.uid).setData(from: xitySupport)
            print("Support Pushed")
        } catch let error {
            NSLog(error.localizedDescription)
        }
        
    }
    
    func trackUsersSupport(xitySupport: XitySupport) {
        xitySupportInstances.append(xitySupport)
    }
}

let xitySupportController = XitySupportController()
