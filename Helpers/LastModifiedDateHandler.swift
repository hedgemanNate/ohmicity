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
    
    
    //MARK: Functions
    // Stores and checks current time and date for fewer data calls
    func loadDate() {
        savedDate = (UserDefaults.standard.object(forKey: "SavedDate") as! Date)
    }
    
    //After database has been queried, save the date
    func saveDate() {
        savedDate = Date()
        UserDefaults.standard.set(savedDate, forKey: "SavedDate")
        print(Timestamp(date: savedDate!))
    }
    
    
    func checkDateAndGetData() {
        if UserDefaults.standard.object(forKey: "SavedDate") == nil {
            NSLog("!*!*!First Open!*!*!")
            //ALL BUSINESS DATA
            businessController.getAllBusinessData { results in
                if results == .failure {
                    NSLog("getAllBusinessData: Failed")
                    notificationCenter.post(notifications.databaseError)
                } else if results == .success {
                    NSLog("getAllBusinessData: Succeeded")
                    notificationCenter.post(notifications.databaseSuccess)
                }
            }
            //ALL SHOW DATA
            showController.getAllShowData { results in
                if results == .failure {
                    NSLog("getAllShowData: Failed")
                    notificationCenter.post(notifications.databaseError)
                } else if results == .success {
                    NSLog("getAllShowData: Succeeded")
                    notificationCenter.post(notifications.databaseSuccess)
                }
            }
            //ALL BAND DATA
            bandController.getAllBandData { results in
                            if results == .failure {
                                NSLog("getAllBandData: Failed")
                                notificationCenter.post(notifications.databaseError)
                            } else if results == .success {
                                NSLog("getAllBandData: Succeeded")
                                notificationCenter.post(notifications.databaseSuccess)
                            }
                        }
            saveDate()
        } else {
            NSLog("!*!*!Repeat Open!*!*!")
            loadDate()
            //NEW BUSINESS DATA
            businessController.getNewBusinessData { results in
                if results == .failure {
                    NSLog("getNewBusinessData: Failed")
                    notificationCenter.post(notifications.databaseError)
                } else if results == .success {
                    NSLog("getNewBusinessData: Succeeded")
                    notificationCenter.post(notifications.databaseSuccess)
                }
            }
            //NEW SHOW DATA
            showController.getNewShowData { results in
                if results == .failure {
                    NSLog("getNewShowData: Failed")
                    notificationCenter.post(notifications.databaseError)
                } else if results == .success {
                    NSLog("getNewShowData: Succeeded")
                    notificationCenter.post(notifications.databaseSuccess)
                }
            }
            //NEW BAND DATA
            bandController.getNewBandData { results in
                if results == .failure {
                    NSLog("getNewBandData: Failed")
                    notificationCenter.post(notifications.databaseError)
                } else if results == .success {
                    NSLog("getNewBandData: Succeeded")
                    notificationCenter.post(notifications.databaseSuccess)
                }
            }
            saveDate()
        }
    }
}

let lmDateHandler = LastModifiedDateHandler()
