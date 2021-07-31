//
//  TimeController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/30/21.
//

import Foundation
import Firebase

class TimeController {
    var todayString = ""
    var thisYear = ""
    
    let dateFormatter = DateFormatter() 
    let dayMonthDayYearTime = "E, MMMM d, yyyy ha" //1
    let dayMonthDay = "E, MMMM d"
    let monthDayYearTime = "MMMM d, yyyy ha" //2
    let monthDayYear = "MMMM d, yyyy" //3
    
    let year = "yyyy"
    
    let now = Date()
    let inFourHours = Date().addingTimeInterval(14400)
    let fourHoursAgo = Date().addingTimeInterval(-14400)
    
    
    func setTime() {
        //For todayString
        dateFormatter.dateFormat = monthDayYear
        todayString = dateFormatter.string(from: now)
            //Manual Date
        todayString = "July 23, 2021"
        
        //For thisYear
        dateFormatter.dateFormat = year
        thisYear = dateFormatter.string(from: now)
    }
}

let timeController = TimeController()
