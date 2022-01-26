//
//  LoadInitDataViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/14/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import MaterialComponents.MaterialActivityIndicator

class LoadInitDataViewController: UIViewController {
    
    var onOpen = true
    //For Debuging the loader
//    var newDataAction = 0 {
//        didSet{
//            print("🚨 New Data Action \(newDataAction)")
//        }
//    }
//    var cacheAction = 0 {
//        didSet{
//            print("🚨 Cache Action \(cacheAction)")
//        }
//    }
//    var allDataAction = 0 {
//        didSet{
//            print("🚨 All Data Action \(allDataAction)")
//        }
//    }
    
    //MARK: Properties
    
    var dataActionsFinished = 0 {
        didSet {
            if onOpen == true {
                print("🔄 Data Actions \(dataActionsFinished)")
                if dataActionsFinished == 8 {
                    organizeData(); print("DATA ACTIONS FIN")
                    removeNotificationObservers()
                }
            }
        }
    }
    
    
    var organizingActionsFinished = 0 {
        didSet{
            print("🔄 Organization Actions\(organizingActionsFinished)")
            if organizingActionsFinished == 4 {
                checkingThatDataExists()
                organizingActionsFinished = 0
            }
        }
    }
    
    var checkingDataActionsFinished = 0 {
        didSet {
            print("🔄 Checking Data Actions\(checkingDataActionsFinished)")
            if checkingDataActionsFinished == 6 {
                checkingDataActionsFinished = 0
                doneLoading()
            }
        }
    }
    
    var failureCounter = 0 {
        didSet {
            NSLog("🚨 Loading Failure: \(failureCounter)/6")
            if failureCounter == 6 {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "FailedSegue", sender: self)
                }
                failureCounter = 0
            }
        }
    }
    
    //Loader
    let activityIndicator = MDCActivityIndicator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        setupProgressView()
        currentUserController.assignCurrentUser()
        subscriptionController.setUpInAppPurchaseArray()
        
        
        //resetCache
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = false
//        settings.isPersistenceEnabled = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if onOpen == true {
            addNotificationObservers()
            lmDateHandler.checkDateAndGetData()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationObservers()
    }
    
    
    @IBAction func breaker(_ sender: Any) {
        
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
        restartCount()
        removeNotificationObservers()
        onOpen = false
        print("✅ DONE LOADING")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ToDashboard", sender: self)
        }
    }
    
    func restartCount() {
        dataActionsFinished = 0
        organizingActionsFinished = 0
        checkingDataActionsFinished = 0
        failureCounter = 0
    }
    
    //MARK: Progress Bar Functions
    private func setupProgressView() {
        activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 1)
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.radius = 150
        activityIndicator.cycleColors = [cc.highlightBlue, UIColor.yellow, UIColor.systemPurple, UIColor.green]
        activityIndicator.startAnimating()
    }
    
    //MARK: UpdateViews
    private func updateViews() {
        timeController.setTime()
        //setTime(enterTime) format July 31, 2021
    }
    
    private func addNotificationObservers() {
        //Cache Loading Notifications
       notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotCacheShowData.name, object: nil)
       notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotCacheBandData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotCacheBusinessData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotCacheBusinessAdData.name, object: nil)
        
        //Database Loading All Notifications
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotAllShowData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotAllBandData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotAllBusinessData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotAllBusinessAdData.name, object: nil)

        //Database Loading New Notifications
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotNewShowData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotNewBandData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotNewBusinessData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotNewBusinessAdData.name, object: nil)
        
        //Network Notifications
        notificationCenter.addObserver(self, selector: #selector(lostNetworkConnection), name: notifications.lostConnection.name, object: nil)
    }
    
    private func removeNotificationObservers() {
        notificationCenter.removeObserver(notifications.gotCacheShowData)
        notificationCenter.removeObserver(notifications.gotCacheBandData)
        notificationCenter.removeObserver(notifications.gotCacheBusinessData)
        notificationCenter.removeObserver(notifications.gotCacheBusinessAdData)
        
        notificationCenter.removeObserver(notifications.gotAllShowData)
        notificationCenter.removeObserver(notifications.gotAllBandData)
        notificationCenter.removeObserver(notifications.gotAllBusinessAdData)
        notificationCenter.removeObserver(notifications.gotAllBusinessData)
        
        notificationCenter.removeObserver(notifications.gotNewShowData)
        notificationCenter.removeObserver(notifications.gotNewBandData)
        notificationCenter.removeObserver(notifications.gotNewBusinessData)
        notificationCenter.removeObserver(notifications.gotNewBusinessAdData)
        
        notificationCenter.removeObserver(notifications.lostConnection)
    }
    
    //@objc Functions
    @objc private func lostNetworkConnection() {
        NSLog("No Connection 📶📶📶📶 ")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "NetworkConnectionSegue", sender: self)
        }
    }
    
    @objc private func counting(_ notification: NSNotification) {
        switch notification.name {
        
        case notifications.gotNewBandData.name:
            dataActionsFinished += 1
            
            print("gotNewBandData")
        case notifications.gotNewBusinessData.name:
            dataActionsFinished += 1
            // For Debuging the loader newDataAction += 1
            print("gotNewBusinessData")
        case notifications.gotNewBusinessAdData.name:
            dataActionsFinished += 1
            // For Debuging the loader newDataAction += 1
            print("gotNewBusinessAdData")
        case notifications.gotNewShowData.name:
            dataActionsFinished += 1
            // For Debuging the loader newDataAction += 1
            print("gotNewShowData")
            
        
        case notifications.gotCacheBandData.name:
            dataActionsFinished += 1
            // For Debuging the loader cacheAction += 1
            print("gotCacheBandData")
        case notifications.gotCacheBusinessData.name:
            dataActionsFinished += 1
            // For Debuging the loader cacheAction += 1
            print("gotCacheBusinessData")
        case notifications.gotCacheShowData.name:
            dataActionsFinished += 1
            // For Debuging the loader cacheAction += 1
            print("gotCacheShowData")
        case notifications.gotCacheBusinessAdData.name:
           dataActionsFinished += 1
            // For Debuging the loader cacheAction += 1
            print("gotCacheBusinessAdData")
        
        
        case notifications.gotAllBandData.name:
            dataActionsFinished += 1
            // For Debuging the loader allDataAction += 1
            print("gotAllBandData")
        case notifications.gotAllBusinessAdData.name:
            dataActionsFinished += 1
            // For Debuging the loader allDataAction += 1
            print("gotAllBusinessAdData")
        case notifications.gotAllBusinessData.name:
            dataActionsFinished += 1
            // For Debuging the loader allDataAction += 1
            print("gotAllBusinessData")
        case notifications.gotAllShowData.name:
            dataActionsFinished += 1
            // For Debuging the loader allDataAction += 1
            print("gotAllShowData")
        default:
            break
        }
    }
    
    //MARK: Checking Data
    private func checkingThatDataExists() {
        //1
        if businessController.businessArray.count >= 66 {
            checkingDataActionsFinished += 1
        } else {
            dataActionsFinished = 0
            organizingActionsFinished = 0
            checkingDataActionsFinished = 0
            failureCounter += 1
            lmDateHandler.retryToGetData()
            NSLog("🚨 Retrying to get more Raw Businesses")
            return
        }
        //2
        if bandController.bandArray.count >= 100 {
            checkingDataActionsFinished += 1
        } else {
            dataActionsFinished = 0
            organizingActionsFinished = 0
            checkingDataActionsFinished = 0
            failureCounter += 1
            lmDateHandler.retryToGetData()
            NSLog("🚨 Retrying to get more Raw Bands")
            return
        }
        //3
        if showController.showArray.count >= 10 {
            checkingDataActionsFinished += 1
        } else {
            dataActionsFinished = 0
            organizingActionsFinished = 0
            checkingDataActionsFinished = 0
            failureCounter += 1
            lmDateHandler.retryToGetData()
            NSLog("🚨 Retrying to get more Raw Shows")
            return
        }
        //4
        if Float(xityBusinessController.businessArray.count) >= Float(businessController.businessArray.count) * 0.10 {
            checkingDataActionsFinished += 1
        } else {
            dataActionsFinished = 0
            organizingActionsFinished = 0
            checkingDataActionsFinished = 0
            failureCounter += 1
            lmDateHandler.retryToGetData()
            NSLog("🚨 Retrying to get more Xity Businesses")
            return
        }
        //5
        if Float(xityBandController.bandArray.count) >= Float(bandController.bandArray.count) * 0.10 {
            checkingDataActionsFinished += 1
        } else {
            dataActionsFinished = 0
            organizingActionsFinished = 0
            checkingDataActionsFinished = 0
            failureCounter += 1
            lmDateHandler.retryToGetData()
            NSLog("🚨 Retrying to get more Xity Bands")
            return
        }
        //6
        if Float(xityShowController.showArray.count) >= Float(showController.showArray.count) * 0.10 {
            checkingDataActionsFinished += 1
        } else {
            dataActionsFinished = 0
            organizingActionsFinished = 0
            checkingDataActionsFinished = 0
            failureCounter += 1
            lmDateHandler.retryToGetData()
            NSLog("🚨 Retrying to get more Xity Shows")
            return
        }
    }
    
    //MARK: Adding shows to Today
    @objc private func organizeData() {
        
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        //Gathering Xity Band And Business Data
        let op2 = BlockOperation {
            xityBandController.fillXityBandArray()
            xityBusinessController.fillXityBusinessArray()
            self.organizingActionsFinished += 1
            print("🫀 Creating Xity Band And Business Data")
        }
        
        //Gathering Weekly Picks
        let op3 = BlockOperation {
            xityShowController.getWeeklyPicks()
            
            self.organizingActionsFinished += 1
            print("🫀 Collected Weekly Picks")
        }
        
        //Connecting Todays Shows to Businesses
        let op4 = BlockOperation {
            //Collected Today's Shows
            dateFormatter.dateFormat = timeController.monthDayYear
            
            for todayShow in xityShowController.showArray {
                let stringDate = dateFormatter.string(from: todayShow.show.date)
                if stringDate == timeController.todayString {
                    xityShowController.todayShowArray.removeAll(where: {$0 == todayShow})
                    xityShowController.todayShowArray.append(todayShow)
                }
            }
            
            //xityShowController.todayShowArray.sort(by: {$0.show.date < $1.show.date})
            self.organizingActionsFinished += 1
            print("🫀 Collected Today's Shows")
        }
        
        let op1 = BlockOperation {
            //Creating Xity Show Data
            let showArray = showController.showArray.filter({$0.date >= timeController.threeHoursAgo})
            
            let businessArray = businessController.businessArray
            let bandArray = bandController.bandArray
            
            for show in showArray {
                
                //This protects against missing bands and missing businesses***
                guard let business = businessArray.first(where: {$0.venueID == show.venue}) else {
                    print("🌇⁉️ No venue found for to make Xity Show")
                    continue
                }
                guard let band = bandArray.first(where: {$0.bandID == show.band}) else {
                    print("🌇⁉️ No band found for to make Xity Show")
                    continue
                }
            
                let xity = XityShow(band: band, business: business, show: show)
                xityShowController.showArray.append(xity)
                
            }
            self.organizingActionsFinished += 1
            print("🫀 Creating Xity Show Data")
        }
        
        
        /*let finalOp = BlockOperation {
            for show in showController.todayShowArray {
                for venue in businessController.businessArray {
                    if show.venue == venue.name {
                        businessController.todayVenueArray.append(venue)
                    }
                }
            }
            self.syncingActionsFinished += 1
            print("***Linking Shows and Venues***")
        }*/
        
        op2.addDependency(op1)
        op3.addDependency(op2)
        op4.addDependency(op3)
        opQueue.addOperations([op1, op2, op3, op4], waitUntilFinished: true)
        
        
    }
    
    
}
