//
//  XityBusinessController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/12/21.
//

import Foundation

class XityBusinessController {
    
    //Properties
    var businessArray = [XityBusiness]()
    
    func fillXityBusinessArray() {
        for business in businessController.businessArray {
            let newBusiness = XityBusiness(business: business)
            for show in xityShowController.showArray {
                if show.business == business {
                    newBusiness.xityShows.append(show)
                }
            }
            let orderedShows = newBusiness.xityShows.sorted(by: {$0.show.date.compare($1.show.date) == .orderedAscending})
            newBusiness.xityShows = orderedShows
            self.businessArray.append(newBusiness)
        }
        businessArray.removeDuplicates()
    }
}

let xityBusinessController = XityBusinessController()
