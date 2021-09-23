//
//  AppDelegate.swift
//  Ohmicity
//
//  Created by Nate Hedgeman on 5/4/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Firebase
        FirebaseApp.configure()
        
//        let fb = Firestore.firestore()
//        fb.clearPersistence { err in
//            if let err = err {
//                NSLog("Cache could not be cleared: \(err)")
//            }
//        }
        
        let settings = FirestoreSettings()
        settings.cacheSizeBytes = 3000000000
        settings.isPersistenceEnabled = true
        
        ref.fireDataBase.settings = settings
        
        
        //Admob
        GADMobileAds.sharedInstance().start(completionHandler: nil) /*set up MEDIATION in here in handler*/
        
        //Network Monitoring
        networkMonitor.startMonitoring()

        //Navigation UI
        UINavigationBar.appearance().backgroundColor = cc.navigationBGPurple
        UINavigationBar.appearance().barTintColor = cc.navigationBGPurple
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:cc.navigationTextBlue
        ]
        
        UIBarButtonItem.appearance().tintColor = cc.navigationTextBlue
        
        let segmentedControlNormalStateTextColor = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let segmentedControlSelectedStateTextColor = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UISegmentedControl.appearance().setTitleTextAttributes(segmentedControlSelectedStateTextColor, for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes(segmentedControlNormalStateTextColor, for: .normal)
        return true
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

