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
import BackgroundTasks

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
        settings.cacheSizeBytes = 2500000000
        settings.isPersistenceEnabled = true
        ref.fireDataBase.settings = settings
        
        
        //Admob
        GADMobileAds.sharedInstance().start(completionHandler: nil) /*set up MEDIATION in here in handler*/
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["3f07752fd3b5455917cd1b1a4d002c27"]
        
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
        
        //Background Tasks
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.push.currentUser", using: nil) { [self] task in
            task.setTaskCompleted(success: true)
            scheduleCurrentUserPush()
        }
        //registerNotifications
        return true
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //cancelAllPendingBGTask()
        scheduleCurrentUserPush()
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

//MARK: BackgroundTasks
extension AppDelegate {
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.push.currentUser", using: nil) { [self] task in
            handleCurrentUserPush(task: task as! BGProcessingTask)
            
        }
    }
    
    func cancelAllPendingBGTask() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
    
    func scheduleCurrentUserPush() {
        print("🚨 Scheduled")
        let request = BGProcessingTaskRequest(identifier: "com.push.currentUser")
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = false
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60)//60 representing a minute
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch (let error) {
            NSLog(error.localizedDescription)
        }
    }
    
    func handleCurrentUserPush(task: BGProcessingTask) {
        print("🚨 Started")
        scheduleCurrentUserPush()
        
        task.expirationHandler = {
            //Cancel All tasks and queues here before the BGProcess Expires
        }
        
        //Check to see if theres new data
        //If so perform pushes
        
        //push user
        //push supports
        //push recommendations
        //push ratings
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        
        let pushUser = BlockOperation {
            print("User Being Pushed BG")
            currentUserController.pushCurrentUserData()
        }
        
        let pushSupport = BlockOperation {
            print("Support Being Pushed BG")
            xitySupportController.pushXitySupportArray()
        }
        
        let pushRecommendation = BlockOperation {
            print("Recommendation Being Pushed BG")
            recommendationController.pushRecommendations()
        }
        
        let pushRating = BlockOperation {
            print("Rating Being Pushed BG")
            ratingsController.pushBandRatings()
        }
        
        let complete = BlockOperation {
            print("Completed")
            task.setTaskCompleted(success: true)
        }
        
        complete.addDependency(pushRating)
        pushRating.addDependency(pushRecommendation)
        pushRecommendation.addDependency(pushSupport)
        pushSupport.addDependency(pushUser)
        
        operationQueue.addOperations([pushUser, pushSupport, pushRecommendation, pushRating, complete], waitUntilFinished: true)
        
    }
    
    
}
