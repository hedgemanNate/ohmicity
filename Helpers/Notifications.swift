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
    let scrollToTop = Notification(name: Notification.Name(rawValue: "ScrollToTop"))
}

let notifications = Notifications()
let notificationCenter = NotificationCenter.init()
