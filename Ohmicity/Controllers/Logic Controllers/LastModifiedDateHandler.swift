//
//  SavedDate.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/9/21.
//

import Foundation
import FirebaseFirestore

class LastModifiedDateHandler {
    //MARK: Properties
    //var savedDate: Date?
    let opQueue = OperationQueue()
    
    
    
    //MARK: Functions
    // Stores and checks current time and date for fewer data calls
    func loadDate() {
        timeController.savedDateForDatabaseUse = (UserDefaults.standard.object(forKey: "SavedDate") as! Date)
        print("!!!!Loading Date: \(timeController.savedDateForDatabaseUse!)")
    }
    
    //After database has been queried, save the date
    func saveDate() {
        timeController.savedDateForDatabaseUse = timeController.remove4HoursForBug
        UserDefaults.standard.set(timeController.savedDateForDatabaseUse, forKey: "SavedDate")
        print("!!!SAVEDDATE: \(Timestamp(date: timeController.savedDateForDatabaseUse!).dateValue())")
    }
    
    func retryToGetData() {
        
        NSLog("!*!*!First Open!*!*!")
        //ALL BUSINESS DATA
        businessController.getAllBusinessData()

        //ALL SHOW DATA
        showController.getAllShowData()
        
        //ALL BAND DATA
        bandController.getAllBandData()
        
        //ALL BANNER DATA
        businessBannerAdController.getAllBusinessAdData()
        saveDate()
    }
    
    func checkDateAndGetData() {
        if UserDefaults.standard.object(forKey: "SavedDate") == nil {
            opQueue.maxConcurrentOperationCount = 1
            
            NSLog("!*!*!First Open!*!*!")
            //ALL BUSINESS DATA
            businessController.getAllBusinessData()

            //ALL SHOW DATA
            showController.getAllShowData()
            
            //ALL BAND DATA
            bandController.getAllBandData()
            
            //ALL BANNER DATA
            businessBannerAdController.getAllBusinessAdData()
            saveDate()
            
            
        } else {
            NSLog("!*!*!Repeat Open!*!*!")
            opQueue.maxConcurrentOperationCount = 1
            
            let preOp = BlockOperation {
                self.loadDate()
            }
            
            let op2 = BlockOperation {
                businessController.getNewBusinessData()
                //Shows are retrieved in op1
                bandController.getAllBandData()
                businessBannerAdController.getNewBusinessAdData()
                self.saveDate()
            }
            
            let op1 = BlockOperation {
                businessBannerAdController.fillBusinessAdArrayFromCache()
                businessController.fillBusinessArrayFromCache()
                showController.getAllShowData()
                bandController.fillBandArrayFromCache()
            }
            
            op1.addDependency(preOp)
            op2.addDependency(op1)
            
            opQueue.addOperations([preOp, op1, op2], waitUntilFinished: true)
        
        }
    }
}

let lmDateHandler = LastModifiedDateHandler()
