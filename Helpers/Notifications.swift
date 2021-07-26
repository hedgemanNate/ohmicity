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
    let businessArraySet = Notification(name: Notification.Name(rawValue: "BusinessArraySet"))
    let showArraySet = Notification(name: Notification.Name(rawValue: "ShowArraySet"))
    let bandArraySet = Notification(name: Notification.Name(rawValue: "BandArraySet"))
    
    let gotBusinessData = Notification(name: Notification.Name(rawValue: "GotBusinessData"))
    let gotBandData = Notification(name: Notification.Name(rawValue: "GotBandData"))
    let gotShowData = Notification(name: Notification.Name(rawValue: "GotShowData"))
    
    let gotCacheBusinessData = Notification(name: Notification.Name(rawValue: "GotCacheBusinessData"))
    let gotCacheBandData = Notification(name: Notification.Name(rawValue: "GotCacheBandData"))
    let gotCacheShowData = Notification(name: Notification.Name(rawValue: "GotCacheShowData"))
    
    let databaseError = Notification(name: Notification.Name(rawValue: "DatabaseError"))
    let databaseSuccess = Notification(name: Notification.Name(rawValue: "DatabaseSuccess"))
    
    //Loading Notifications
    let organizeData = Notification(name: Notification.Name(rawValue: "OrganizeData"))
}

let notifications = Notifications()
let notificationCenter = NotificationCenter.init()
