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
    var todayVenueArray: [BusinessFullData] = []
    var todayDate = ""
    
    
    var dataActionsFinished = 0 {
        didSet {
            print(dataActionsFinished)
            if dataActionsFinished == 7 {
                organizeData(); print("DATA ACTIONS FIN")
            }
        }
    }
    
    
    var syncingActionsFinished = 0 { didSet { if dataActionsFinished == 2 { print("DONE LOADING")}}}
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObservers()
        assignCurrentUser()
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
    
    private func getTodaysDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        //todayDate = dateFormatter.string(from: Date())
        todayDate = "July 17, 2021"
    }
    
    private func doneLoading() {
        print("**DONE LOADING FUNC****")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ToDashboard", sender: self)
        }
    }
    
    private func assignCurrentUser() {
        guard let id = Auth.auth().currentUser?.uid else { return NSLog("No Current User ID: assignCurrentUser") }
        guard let email = Auth.auth().currentUser?.email else { return NSLog("No Current User Email: assignCurrentUser") }
        
        currentUser = CurrentUser(userID: id, email: email)
        }
        
    
    //MARK: UpdateViews
    private func updateViewController() {
        dateFormatter.dateFormat = dateFormat3
        getTodaysDate()
        
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
                
                if stringDate == self.todayDate {
                    showController.todayShowArray.append(show)
                }
            }
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
            print("***Synced Data***")
        }
        
        
        let finalOp = BlockOperation {
            self.doneLoading()
        }
        
        op2.addDependency(op1)
        finalOp.addDependency(op2)
        opQueue.addOperations([op1, op2, finalOp], waitUntilFinished: true)
        
        
    }
    
    
}
