//
//  XityPicksController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/5/21.
//

import Foundation

class XityShowController {
    
    //Properties
    var showArray = [XityShow]()
    var todayShowArray = [XityShow]()
    var weeklyPicksArray = [XityShow]()
    var xityShowSearchArray = [XityShow]()
    
    func removeDuplicates() {
        let xitySet = Set(showArray)
        showArray = Array(xitySet)
    }
    
    func getWeeklyPicks() {
        let today = Date()
        let monday = Date().next(.monday)
        
        var lowFiltered = [XityShow]()
        var theWeekFiltered = [XityShow]()
        
        let op1 = BlockOperation { [self] in
            lowFiltered = showArray.filter({$0.show.date > today})
            print("******lowFiltered")
        }
        
        let op2 = BlockOperation {
            theWeekFiltered = lowFiltered.filter({$0.show.date < monday})
            print("******theWeekFiltered")
            print(monday)
        }
        
        let op3 = BlockOperation { [self] in
            let mid = theWeekFiltered.filter({$0.show.ohmPick == true})
            weeklyPicksArray = mid.sorted(by: {$0.show.date < $1.show.date})
            print("******Xity Picks!")
        }
        
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        op3.addDependency(op2)
        op2.addDependency(op1)
        opQueue.addOperations([op1, op2, op3], waitUntilFinished: false)
    }
}

let xityShowController = XityShowController()
