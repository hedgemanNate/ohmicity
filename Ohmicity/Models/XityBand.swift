//
//  XityBand.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/12/21.
//

import Foundation

class XityBand: Equatable, Hashable {
    static func == (lhs: XityBand, rhs: XityBand) -> Bool {
        lhs.band.bandID == rhs.band.bandID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(band)
    }
    
    
    let band: Band
    var xityShows = [XityShow]()
    
    init(band: Band) {
        self.band = band
    }
}
