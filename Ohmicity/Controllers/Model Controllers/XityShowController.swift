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
    
    var todayShowArray: [XityShow] = [] {
        didSet {
            let xitySet = Set(showArray)
            showArray = Array(xitySet)
            todayShowResultsArray = todayShowArray
        }
    }
    var todayShowResultsArray: [XityShow] = [] {
        didSet {
            todayShowResultsArray.sort(by: {$0.show.date < $1.show.date})
        }
    }
    var weeklyPicksArray = [XityShow]() {
        didSet {
            let set = Set(weeklyPicksArray)
            weeklyPicksArray = Array(set)
            weeklyPicksArray.sort(by: {$0.show.date < $1.show.date})
        }
    }
    var xityShowSearchArray = [XityShow]()
    
    var todayShowArrayFilter: City = .All {
        didSet {
            todayShowResultsArray = todayShowArray.filter({$0.show.city.contains(todayShowArrayFilter)})
            notificationCenter.post(notifications.reloadDashboardCVData)
        }
    }
    
    func getWeeklyPicks() {
        weeklyPicksArray = []
        let monday = Date().next(.monday)
        
        var lowFiltered = [XityShow]()
        var theWeekFiltered = [XityShow]()
        
        let op1 = BlockOperation { [self] in
            lowFiltered = showArray.filter({$0.show.date > timeController.threeHoursAgo})
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
    
    func fillXityShowArray() {
        for show in showController.showArray {
            guard let band = bandController.bandArray.first(where: {$0.bandID == show.band}) else {continue}
            guard let business = businessController.businessArray.first(where: {$0.venueID == show.venue}) else {continue}
            
            let xityShow = XityShow(band: band, business: business, show: show)
            showArray.append(xityShow)
        }
    }
}

let xityShowController = XityShowController()
