//
//  RemoteControlModel.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 2/24/22.
//

import Foundation

class RemoteControllerModel: Decodable {
    
    static var adPercentArray: [Int] = [1,2,3,4,5]
    var shutDown: Bool = false
    var maintenanceMode: Bool = false
    var alert: String?
    
}


