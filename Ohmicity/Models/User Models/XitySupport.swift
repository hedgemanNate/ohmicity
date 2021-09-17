//
//  XitySupportModel.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/17/21.
//

import Foundation

struct XitySupport: Equatable, Codable {
    let uid: String
    let userID: String
    let bandName: String
    let time: Date
    
    static func == (lhs: XitySupport, rhs: XitySupport) -> Bool {
        lhs.uid == rhs.uid
    }
    
    init(userID: String, bandName: String) {
        self.uid = UUID().uuidString
        self.userID = userID
        self.bandName = bandName
        self.time = Date()
    }
    
}
