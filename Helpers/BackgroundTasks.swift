//
//  BackgroundTasks.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/26/21.
//

import Foundation
import BackgroundTasks

class CustomBackgroundTasks {
    
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
        
        let complete = BlockOperation {
            task.setTaskCompleted(success: true)
        }
        
        complete.addDependency(pushUser)
        
        operationQueue.addOperations([pushUser, complete], waitUntilFinished: true)
        
    }
    
    
}

let customBackgroundTasks = CustomBackgroundTasks()
