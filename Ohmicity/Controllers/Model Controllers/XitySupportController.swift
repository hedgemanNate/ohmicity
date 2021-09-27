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
    var supportInstancesArray = [XitySupport]()
     
    func pushXitySupport() {
        if supportInstancesArray != [] {
            for support in supportInstancesArray {
                do {
                    try ref.xitySupportDataPath.document(support.uid).setData(from: support)
                    NSLog("✅ Support Pushed")
                } catch (let error) {
                    NSLog("🚨 \(error.localizedDescription)")
                }
            }
        }
    }
    
    func addUsersSupportToArray(xitySupport: XitySupport) {
        supportInstancesArray.append(xitySupport)
    }
}

let xitySupportController = XitySupportController()
