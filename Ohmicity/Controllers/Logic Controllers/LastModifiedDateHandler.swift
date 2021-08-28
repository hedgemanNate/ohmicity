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
    var savedDate: Date?
    let opQueue = OperationQueue()
    
    
    
    //MARK: Functions
    // Stores and checks current time and date for fewer data calls
    func loadDate() {
        savedDate = (UserDefaults.standard.object(forKey: "SavedDate") as! Date)
    }
    
    //After database has been queried, save the date
    func saveDate() {
        savedDate = Date()
        UserDefaults.standard.set(savedDate, forKey: "SavedDate")
        print("!!!SAVEDDATE: \(Timestamp(date: savedDate!).dateValue())")
    }
    
    
    
    func checkDateAndGetData() {
        if UserDefaults.standard.object(forKey: "SavedDate") == nil {
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
                showController.getNewShowData()
                bandController.getNewBandData()
                businessBannerAdController.getNewBusinessAdData()
                self.saveDate()
            }
            
            let op1 = BlockOperation {
                businessBannerAdController.fillArrayFromCache()
                businessController.fillArrayFromCache()
                showController.fillArrayFromCache()
                bandController.fillArrayFromCache()
            }
            
            op1.addDependency(preOp)
            op2.addDependency(op1)
            
            opQueue.addOperations([preOp, op1, op2], waitUntilFinished: true)
        
        }
    }
}

let lmDateHandler = LastModifiedDateHandler()
