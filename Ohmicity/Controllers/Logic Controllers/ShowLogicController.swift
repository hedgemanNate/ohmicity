//
//  ShowLogicController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 3/3/22.
//

import Foundation

class ShowLogicController {
    
    static func buildTodayShows() {
        let group = DispatchGroup()
        timeController.setTime()
        
        group.enter()
        dateFormatter.dateFormat = timeController.monthDayYear
        XityShowController.todayShowArray.removeAll()
        XityShowController.todayShowResultsArray.removeAll()
        
        for todayShow in XityShowController.showArray {
            let stringDate = dateFormatter.string(from: todayShow.show.date)
            if stringDate == timeController.todayString {
                XityShowController.todayShowArray.append(todayShow)
            }
        }
        
        XityShowController.todayShowResultsArray = XityShowController.todayShowArray
        XityShowController.todayShowArrayFilter = .All
        
        print("Today Built")
        group.leave()
        
        group.notify(queue: .global()) {
            self.buildWeeklyPicks()
        }
    }
    
    static func buildWeeklyPicks() {
        let group = DispatchGroup()
        
        group.enter()
        let monday = Date().next(.monday)
        
        var lowFiltered = [XityShow]()
        var theWeekFiltered = [XityShow]()
        
        let op1 = BlockOperation {
            lowFiltered = XityShowController.showArray.filter({$0.show.date > timeController.threeHoursAgo})
            print("******lowFiltered")
        }
        
        let op2 = BlockOperation {
            theWeekFiltered = lowFiltered.filter({$0.show.date < monday})
            print("******theWeekFiltered")
            print(monday)
        }
        
        let op3 = BlockOperation {
            let mid = theWeekFiltered.filter({$0.show.ohmPick == true})
            XityShowController.weeklyPicksArray.removeAll()
            XityShowController.weeklyPicksArray = mid.sorted(by: {$0.show.date < $1.show.date})
            print("******Xity Picks!")
        }
        
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        op3.addDependency(op2)
        op2.addDependency(op1)
        opQueue.addOperations([op1, op2, op3], waitUntilFinished: true)
        
        print("Weeks Built")
        group.leave()
        
        group.notify(queue: .global()) {
            print("Completed Show Logic Controller")
            NotifyCenter.post(Notifications.reloadAllData)
        }
    }
}
