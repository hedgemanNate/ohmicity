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
    
    
    func checkDateAndGetData(complete:() -> Void) {
        if UserDefaults.standard.object(forKey: "SavedDate") == nil {
            NSLog("!*!*!First Open!*!*!")
            //ALL BUSINESS DATA
            businessController.getAllBusinessData()

            //ALL SHOW DATA
            showController.getAllShowData()
            
            //ALL BAND DATA
            bandController.getAllBandData()
            saveDate()
            complete()
        } else {
            NSLog("!*!*!Repeat Open!*!*!")
            loadDate()
            //NEW BUSINESS DATA
            businessController.getNewBusinessData()
            businessController.fillArray()
            
            //NEW SHOW DATA
            showController.getNewShowData()
            showController.fillArray()
            
            //NEW BAND DATA
            bandController.getNewBandData()
            bandController.fillArray()
            saveDate()
            complete()
        }
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
            
            //TEMP BANNER DATA
            bannerAdController.fillArray()
            saveDate()
        } else {
            NSLog("!*!*!Repeat Open!*!*!")
            opQueue.maxConcurrentOperationCount = 1
            
            let preOp = BlockOperation {
                self.loadDate()
            }
            
            let op1 = BlockOperation {
                
                businessController.getNewBusinessData()
                showController.getNewShowData()
                bandController.getNewBandData()
            }
            
            let op2 = BlockOperation {
                bannerAdController.fillArray()
                businessController.fillArray()
                showController.fillArray()
                bandController.fillArray()
                self.saveDate()
            }
            
            let op3 = BlockOperation {
                
            }
            
            op1.addDependency(preOp)
            op2.addDependency(op1)
            op3.addDependency(op2)
            
            opQueue.addOperations([preOp, op1, op2, op3], waitUntilFinished: true)
        
        }
    }
}

let lmDateHandler = LastModifiedDateHandler()
