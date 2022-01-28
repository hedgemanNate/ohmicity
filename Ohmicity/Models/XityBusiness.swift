//
//  XityBusiness.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/12/21.
//

import Foundation

class XityBusiness: Equatable, Hashable {
    //Properties
    let business: Business
    var xityShows = [XityShow]() {
        didSet {
            let set = Set(xityShows)
            xityShows = Array(set)
            xityShows.sort(by: {$0.show.date < $1.show.date})
        }
    }
    
    static func == (lhs: XityBusiness, rhs: XityBusiness) -> Bool {
        return lhs.business.venueID == rhs.business.venueID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(business)
    }
    
    
    
    
    init(venue: Business) {
        self.business = venue
        
        for show in XityShowController.showArray {
            if show.business.venueID == venue.venueID {
                self.xityShows.append(show)
            }
        }
        
        XityBusinessController.businessArray.append(self)
    }
}
