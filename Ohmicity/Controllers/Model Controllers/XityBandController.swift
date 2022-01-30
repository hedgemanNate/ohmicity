//
//  XityBandController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/12/21.
//

import Foundation

class XityBandController {
    
    //Properties
    static var bandArray = [XityBand]() {
        didSet {
            let set = Set(bandArray)
            bandArray = Array(set)
            bandArray.sort(by: {$0.band.name < $1.band.name})
        }
    }
}

