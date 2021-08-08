//
//  XityPicksController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/5/21.
//

import Foundation

class XityShowController {
    
    //Properties
    var xityData = [XityShow]()
    var weeklyPicksArray = [XityShow]()
    var xityShowSearchArray = [XityShow]()
    
    func getWeeklyPicks() {
        let today = Date()
        let monday = Date().next(.monday)
        
        var lowFiltered = [Show]()
        var theWeekFiltered = [Show]()
        var xityPicks = [Show]()
        
        let op1 = BlockOperation {
            lowFiltered = showController.showArray.filter({$0.date > today})
            print("******lowFiltered")
        }
        
        let op2 = BlockOperation {
            theWeekFiltered = lowFiltered.filter({$0.date < monday})
            print("******theWeekFiltered")
            print(monday)
        }
        
        let op3 = BlockOperation {
            xityPicks = theWeekFiltered.filter({$0.ohmPick == true})
            print("******Xity Picks!")
        }
        
        let op4 = BlockOperation {
            for show in xityPicks {
                guard let business = businessController.businessArray.first(where: {$0.name == show.venue}) else {return}
                guard let band = bandController.bandArray.first(where: {$0.name == show.band}) else {return}
                
                let xityPick = XityShow(band: band, business: business, show: show)
                self.weeklyPicksArray.append(xityPick)
            }
        }
        
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        op4.addDependency(op3)
        op3.addDependency(op2)
        op2.addDependency(op1)
        opQueue.addOperations([op1, op2, op3, op4], waitUntilFinished: false)
    }
}

let xityShowController = XityShowController()
