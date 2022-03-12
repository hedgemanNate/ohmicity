//
//  Notifications.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/8/21.
//

import Foundation
import FirebaseAuth

class Notifications {
    
    //Remote Controller Notifications
    static let remoteControlUpdated = Notification(name: Notification.Name(rawValue: "RemoteControlUpdated"))
    
    //User Notifications
    static let userAuthUpdated = Notification(name: Notification.Name(rawValue: "UserAuthUpdated"))
    static let userFavoritesUpdated = Notification(name: Notification.Name(rawValue: "UserFavoritesUpdated"))
    static let userSubscriptionUpdated = Notification(name: Notification.Name(rawValue: "UserSubscriptionUpdated"))
    
    //UI Notifications
    static let scrollToTop = Notification(name: Notification.Name(rawValue: "ScrollToTop"))
    static let dismiss = Notification(name: Notification.Name(rawValue: "Dismiss"))
    static let modalDismissed = Notification(name: Notification.Name(rawValue: "ModalDismissed"))
    
    //Database Notifications
    static let businessArraySet = Notification(name: Notification.Name(rawValue: "BusinessArraySet"))
    static let showArraySet = Notification(name: Notification.Name(rawValue: "ShowArraySet"))
    static let bandArraySet = Notification(name: Notification.Name(rawValue: "BandArraySet"))
    static let businessAdArraySet = Notification(name: Notification.Name(rawValue: "BusinessAdArraySet"))
    
    static let gotNewBusinessData = Notification(name: Notification.Name(rawValue: "GotBusinessData"))
    static let gotNewBandData = Notification(name: Notification.Name(rawValue: "GotBandData"))
    static let gotNewShowData = Notification(name: Notification.Name(rawValue: "GotShowData"))
    
    
    static let gotAllBusinessData = Notification(name: Notification.Name(rawValue: "GotAllBusinessData"))
    static let gotAllBandData = Notification(name: Notification.Name(rawValue: "GotAllBandData"))
    static let gotAllShowData = Notification(name: Notification.Name(rawValue: "GotAllShowData"))
    
    
    static let gotCacheBusinessData = Notification(name: Notification.Name(rawValue: "GotCacheBusinessData"))
    static let gotCacheBandData = Notification(name: Notification.Name(rawValue: "GotCacheBandData"))
    static let gotCacheShowData = Notification(name: Notification.Name(rawValue: "GotCacheShowData"))
    
    
    static let databaseError = Notification(name: Notification.Name(rawValue: "DatabaseError"))
    static let databaseSuccess = Notification(name: Notification.Name(rawValue: "DatabaseSuccess"))
    
    //Business Ad Notifications
    static let gotAllBusinessAdData = Notification(name: Notification.Name(rawValue: "GotAllBusinessAdData"))
    static let gotNewBusinessAdData = Notification(name: Notification.Name(rawValue: "GotBusinessAdData"))
    static let gotCacheBusinessAdData = Notification(name: Notification.Name(rawValue: "GotCacheBusinessAdData"))
    
    //Loading Steps
    static let forceUpdate = Notification(name: Notification.Name(rawValue: "ForceUpdate"))
    //static let updateAvailable = Notification(name: Notification.Name(rawValue: "UpdateAvailable"))
    //static let op3Finished = Notification(name: Notification.Name(rawValue: "op3Finished"))
    
    //Network Notifications
    static let lostConnection = Notification(name: Notification.Name(rawValue: "lostConnection"))
    static let hasConnection = Notification(name: Notification.Name(rawValue: "hasConnection"))
    
    
    //Dashboard Notifications
    static let reloadDashboardCVData = Notification(name: Notification.Name(rawValue: "reloadDashboardCVData"))
    
    //Reload All Data Notifications
    static let reloadAllData = Notification(name: Notification.Name(rawValue: "ReloadAllData"))
}

let NotifyCenter = NotificationCenter.init()
