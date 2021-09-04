//
//  XityBandController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/12/21.
//

import Foundation

class XityBandController {
    
    //Properties
    var bandArray = [XityBand]()
    
    func fillXityBandArray() {
        for band in bandController.bandArray {
            let newBand = XityBand(band: band)
            for show in xityShowController.showArray {
                if show.band == band {
                    newBand.xityShows.append(show)
                }
            }
            let orderedShows = newBand.xityShows.sorted(by: {$0.show.date.compare($1.show.date) == .orderedAscending})
            newBand.xityShows = orderedShows
            self.bandArray.append(newBand)
        }
        bandArray.removeDuplicates()
    }
}

let xityBandController = XityBandController()
