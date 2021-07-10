//
//  Notifications.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/8/21.
//

import Foundation
import FirebaseAuth

class Notifications {
    
    let userAuthUpdated = Notification(name: Notification.Name(rawValue: "UserAuthUpdated"))
    
    //UI Notifications
    let scrollToTop = Notification(name: Notification.Name(rawValue: "ScrollToTop"))
    
    //Databass Notifications
    let databaseError = Notification(name: Notification.Name(rawValue: "DatabaseError"))
    let databaseSuccess = Notification(name: Notification.Name(rawValue: "DatabaseSuccess"))
}

let notifications = Notifications()
let notificationCenter = NotificationCenter.init()
