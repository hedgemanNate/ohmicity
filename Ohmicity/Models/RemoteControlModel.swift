//
//  RemoteControlModel.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 2/24/22.
//

import Foundation

class RemoteControllerModel: Decodable {
    
    var adPercentArray: [Int] = remoteAdArrays.fifty
    var shutDown: Bool = false
    var maintenanceMode: Bool = false
    var alert: String?
}

struct RemoteAdArrays: Encodable {
    let zero = [0]
    let forty = [1,2,3,4]
    let fifty = [1,2,3,4,5]
    let sixty = [1,2,3,4,5,6]
    let seventy = [1,2,3,4,5,6,7]
    let eighty = [1,2,3,4,5,6,7,8]
    let ninety = [1,2,3,4,5,6,7,8,9]
    let oneHundred = [1,2,3,4,5,6,7,8,9,10]
}

let remoteAdArrays = RemoteAdArrays()


