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
    static var showArray: [Show] = [] {didSet {}}
    
    //Functions
    static func removeHolds() {
        showArray.removeAll(where: {$0.onHold == true})
    }
}
