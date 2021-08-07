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
    var dayOfWeek = ""
    
    let dateFormatter = DateFormatter() 
    let dayMonthDayYearTime = "E, MMMM d, yyyy ha" //1
    let dayMonthDay = "E, MMMM d"
    let monthDayYearTime = "MMMM d, yyyy ha" //2
    let monthDayYear = "MMMM d, yyyy" //3
    let day = "E"
    
    let year = "yyyy"
    
    let now = Date()
    let inTwoHours = Date().addingTimeInterval(7200)
    let twoHoursAgo = Date().addingTimeInterval(-7200)
    
    //Calendar
    let userCalendar = Calendar.current
    
    
    //Functions
    func setTime() {
        //For todayString
        dateFormatter.dateFormat = monthDayYear
        todayString = dateFormatter.string(from: now)
        
        //For thisYear
        dateFormatter.dateFormat = year
        thisYear = dateFormatter.string(from: now)
        
        //For today's day of the week
        dateFormatter.dateFormat = day
        dayOfWeek = dateFormatter.string(from: now)
    }
    
    func setTime(enterTime: String) {
        setTime()
        todayString = enterTime
    }
    
}

let timeController = TimeController()
