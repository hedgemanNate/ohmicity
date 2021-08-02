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
    let inTwoHours = Date().addingTimeInterval(7200)
    let twoHoursAgo = Date().addingTimeInterval(-7200)
    
    
    //Timers
    var timer = Timer()
    
    func setTime() {
        //For todayString
        dateFormatter.dateFormat = monthDayYear
        todayString = dateFormatter.string(from: now)
            //Manual Date
        //todayString = "July 31, 2021"
        
        //For thisYear
        dateFormatter.dateFormat = year
        thisYear = dateFormatter.string(from: now)
    }
    
}

let timeController = TimeController()
