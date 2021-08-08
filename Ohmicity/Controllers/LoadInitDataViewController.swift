//
//  LoadInitDataViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/14/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class LoadInitDataViewController: UIViewController {
    
    //Properties
    var todayShowArray: [Show] = []
    var todayVenueArray: [Business] = []
    
    
    var dataActionsFinished = 0 {
        didSet {
            print(dataActionsFinished)
            if dataActionsFinished == 7 {
                organizeData(); print("DATA ACTIONS FIN")
            }
        }
    }
    
    
    var syncingActionsFinished = 0 {
        didSet{
            print(syncingActionsFinished)
            if syncingActionsFinished == 3 {
                doneLoading()
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObservers()
        currentUserController.assignCurrentUser()
        updateViewController()
        lmDateHandler.checkDateAndGetData()
        
        
        //resetCache
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = false
//        settings.isPersistenceEnabled = true
        
    }
    @IBAction func btn(_ sender: Any) {
        print("****Tapped****")
    }
    

    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

//MARK: Functions
extension LoadInitDataViewController {
    
    func doneLoading() {
        print("**DONE LOADING FUNC****")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ToDashboard", sender: self)
        }
    }
        
    
    //MARK: UpdateViews
    private func updateViewController() {
        dateFormatter.dateFormat = dateFormat3
        timeController.setTime()
        //setTime(enterTime) format July 31, 2021
    }
    
    private func addNotificationObservers() {
        //Cache Loading Notifications
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotCacheShowData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotCacheBandData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotCacheBusinessData.name, object: nil)
        
        //Database Loading Notifications
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotAllShowData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotAllBandData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotAllBusinessData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotShowData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotBandData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotBusinessData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.bannerAdsLoaded.name, object: nil)
    }
    
    //@objc Functions
    @objc private func counting(_ notification: NSNotification) {
        
        
        switch notification.name {
        case notifications.bandArraySet.name:
            dataActionsFinished += 1
        case notifications.bannerAdsCollected.name:
            dataActionsFinished += 1
        case notifications.bannerAdsLoaded.name:
            dataActionsFinished += 1
        case notifications.businessArraySet.name:
            dataActionsFinished += 1
        case notifications.gotBandData.name:
            dataActionsFinished += 1
        case notifications.gotBusinessData.name:
            dataActionsFinished += 1
        case notifications.gotCacheBandData.name:
            dataActionsFinished += 1
        case notifications.gotCacheBusinessData.name:
            dataActionsFinished += 1
        case notifications.gotShowData.name:
            dataActionsFinished += 1
        case notifications.gotCacheShowData.name:
            dataActionsFinished += 1
        case notifications.gotAllBandData.name:
            dataActionsFinished += 2
        case notifications.gotAllBusinessData.name:
            dataActionsFinished += 2
        case notifications.gotAllShowData.name:
            dataActionsFinished += 2
            
        default:
            break
        }
    }
    
    //MARK: Adding shows to Today
    @objc private func organizeData() {
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        //Locating Todays Shows
        let op1 = BlockOperation {
            for show in showController.showArray {
                let stringDate = dateFormatter.string(from: show.date)
                
                if stringDate == timeController.todayString {
                    showController.todayShowArray.append(show)
                    showController.todayShowArray.removeDuplicates()
                }
            }
            xityShowController.getWeeklyPicks()
            self.syncingActionsFinished += 1
            print("***Collected Shows For Today***")
        }
        
        //Connecting Todays Shows to Businesses
        let op2 = BlockOperation {
            for show in showController.todayShowArray {
                for venue in businessController.businessArray {
                    if show.venue == venue.name {
                        businessController.todayVenueArray.append(venue)
                    }
                }
            }
            self.syncingActionsFinished += 1
            print("***Linking Shows and Venues***")
        }
        
        let op3 = BlockOperation {
            print("op3 Started")
            let showArray = showController.showArray.filter({$0.date >= timeController.twoHoursAgo})
            
            let businessArray = businessController.businessArray
            let bandArray = bandController.bandArray
            
            for show in showArray {
                let band = bandArray.first(where: {$0.name == show.band})
                let business = businessArray.first(where: {$0.name == show.venue})
                let xity = XityShow(band: band!, business: business!, show: show)
                xityShowController.xityData.append(xity)
                
            }
            self.syncingActionsFinished += 1
            print("***Creating Xity Data")
        }
        
        
//        let finalOp = BlockOperation {
//            self.doneLoading()
//        }
        
        op2.addDependency(op1)
        op3.addDependency(op2)
        opQueue.addOperations([op1, op2, op3], waitUntilFinished: true)
        
        
    }
    
    
}
