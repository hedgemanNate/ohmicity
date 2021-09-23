//
//  Notifications.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/8/21.
//

import Foundation
import FirebaseAuth

class Notifications {
    
    //User Notifications
    let userAuthUpdated = Notification(name: Notification.Name(rawValue: "UserAuthUpdated"))
    let userFavoritesUpdated = Notification(name: Notification.Name(rawValue: "UserFavoritesUpdated"))
    
    //UI Notifications
    let scrollToTop = Notification(name: Notification.Name(rawValue: "ScrollToTop"))
    let dismiss = Notification(name: Notification.Name(rawValue: "Dismiss"))
    
    //Database Notifications
    let businessArraySet = Notification(name: Notification.Name(rawValue: "BusinessArraySet"))
    let showArraySet = Notification(name: Notification.Name(rawValue: "ShowArraySet"))
    let bandArraySet = Notification(name: Notification.Name(rawValue: "BandArraySet"))
    let businessAdArraySet = Notification(name: Notification.Name(rawValue: "BusinessAdArraySet"))
    
    let gotNewBusinessData = Notification(name: Notification.Name(rawValue: "GotBusinessData"))
    let gotNewBandData = Notification(name: Notification.Name(rawValue: "GotBandData"))
    let gotNewShowData = Notification(name: Notification.Name(rawValue: "GotShowData"))
    
    
    let gotAllBusinessData = Notification(name: Notification.Name(rawValue: "GotAllBusinessData"))
    let gotAllBandData = Notification(name: Notification.Name(rawValue: "GotAllBandData"))
    let gotAllShowData = Notification(name: Notification.Name(rawValue: "GotAllShowData"))
    
    
    let gotCacheBusinessData = Notification(name: Notification.Name(rawValue: "GotCacheBusinessData"))
    let gotCacheBandData = Notification(name: Notification.Name(rawValue: "GotCacheBandData"))
    let gotCacheShowData = Notification(name: Notification.Name(rawValue: "GotCacheShowData"))
    
    
    let databaseError = Notification(name: Notification.Name(rawValue: "DatabaseError"))
    let databaseSuccess = Notification(name: Notification.Name(rawValue: "DatabaseSuccess"))
    
    //Business Ad Notifications
    let gotAllBusinessAdData = Notification(name: Notification.Name(rawValue: "GotAllBusinessAdData"))
    let gotNewBusinessAdData = Notification(name: Notification.Name(rawValue: "GotBusinessAdData"))
    let gotCacheBusinessAdData = Notification(name: Notification.Name(rawValue: "GotCacheBusinessAdData"))
    
    //Loading Steps
    let op1Finished = Notification(name: Notification.Name(rawValue: "op1Finished"))
    let op2Finished = Notification(name: Notification.Name(rawValue: "op2Finished"))
    let op3Finished = Notification(name: Notification.Name(rawValue: "op3Finished"))
    
    //UI
    let modalDismissed = Notification(name: Notification.Name(rawValue: "ModalDismissed"))
    
    //Dashboard notifications
    let reloadDashboardCVData = Notification(name: Notification.Name(rawValue: "reloadDashboardCVData"))
}

let notifications = Notifications()
let notificationCenter = NotificationCenter.init()
