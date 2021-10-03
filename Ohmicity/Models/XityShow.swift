//
//  XityPick.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/6/21.
//

import Foundation
import CloudKit

class XityShow: Equatable, Hashable {
    static func == (lhs: XityShow, rhs: XityShow) -> Bool {
        return lhs.show == rhs.show
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(show)
    }
    
    //Properties
    var band: Band
    var business: Business
    var show: Show
    
    
    init(band: Band, business: Business, show: Show) {
        self.band = band
        self.business = business
        self.show = show
    }
}
