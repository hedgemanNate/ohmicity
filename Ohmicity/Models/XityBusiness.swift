//
//  XityBusiness.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/12/21.
//

import Foundation

class XityBusiness: Equatable, Hashable {
    static func == (lhs: XityBusiness, rhs: XityBusiness) -> Bool {
        return lhs.business.venueID == rhs.business.venueID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(business)
    }
    
    //Properties
    let business: Business
    var xityShows = [XityShow]()
    
    
    init(business: Business) {
        self.business = business
    }
}
