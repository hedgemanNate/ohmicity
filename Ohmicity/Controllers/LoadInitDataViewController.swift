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
    
    //Properties
    var todayShowArray: [Show] = []
    var todayVenueArray: [Business] = []
    
    
    var dataActionsFinished = 0 {
        didSet {
            print("####Current Data Action Amount: \(dataActionsFinished)")
            if dataActionsFinished >= 8 {
                organizeData(); print("DATA ACTIONS FIN")
            }
        }
    }
    
    
    var syncingActionsFinished = 0 {
        didSet{
            print(syncingActionsFinished)
            if syncingActionsFinished == 4 {
                doneLoading()
            }
        }
    }
    
    //Loader
    let activityIndicator = MDCActivityIndicator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObservers()
        updateViewController()
        setupProgressView()
        currentUserController.assignCurrentUser()
        subscriptionTypeController.setUpInAppPurchaseArray()
        lmDateHandler.checkDateAndGetData()
        
        //resetCache
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = false
//        settings.isPersistenceEnabled = true
        
    }
    
    @IBAction func breaker(_ sender: Any) {
        print(businessBannerAdController.businessAdArray)
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
    private func updateViewController() {
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
    }
    
    //@objc Functions
    @objc private func counting(_ notification: NSNotification) {

        switch notification.name {
        
        case notifications.gotNewBandData.name:
            dataActionsFinished += 1
            print("gotNewBandData")
        case notifications.gotNewBusinessData.name:
            dataActionsFinished += 1
            print("gotNewBusinessData")
        case notifications.gotNewBusinessAdData.name:
            dataActionsFinished += 1
            print("gotNewBusinessAdData")
        case notifications.gotNewShowData.name:
            dataActionsFinished += 1
            print("gotNewShowData")
            
        
        case notifications.gotCacheBandData.name:
            dataActionsFinished += 1
            print("gotCacheBandData")
        case notifications.gotCacheBusinessData.name:
            dataActionsFinished += 1
            print("gotCacheBusinessData")
        case notifications.gotCacheShowData.name:
            dataActionsFinished += 1
            print("gotCacheShowData")
        case notifications.gotCacheBusinessAdData.name:
           dataActionsFinished += 1
            print("gotCacheBusinessAdData")
        
        
        case notifications.gotAllBandData.name:
            dataActionsFinished += 1
            print("gotAllBandData")
        case notifications.gotAllBusinessAdData.name:
            dataActionsFinished += 1
            print("gotAllBusinessAdData")
        case notifications.gotAllBusinessData.name:
            dataActionsFinished += 1
            print("gotAllBusinessData")
        case notifications.gotAllShowData.name:
            dataActionsFinished += 1
            print("gotAllShowData")
        default:
            break
        }
    }
    
    //MARK: Adding shows to Today
    @objc private func organizeData() {
        //Collected Weekly Picks
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        //Gathering Xity Band And Business Data
        let op2 = BlockOperation {
            xityBandController.fillXityBandArray()
            xityBusinessController.fillXityBusinessArray()
            self.syncingActionsFinished += 1
            print("*** Creating Xity Band And Business Data ***")
        }
        
        //Gathering Weekly Picks
        let op3 = BlockOperation {
            xityShowController.getWeeklyPicks()
            //xityShowController.weeklyPicksArray.sort(by: {$0.show.date < $1.show.date})
            
            self.syncingActionsFinished += 1
            print("*** Collected Weekly Picks ***")
        }
        
        //Connecting Todays Shows to Businesses
        let op4 = BlockOperation {
            //Collected Today's Shows
            dateFormatter.dateFormat = timeController.monthDayYear
            
            //Initialize todayShowArray to prevent crashing because it is optional and can be nil
            xityShowController.todayShowArray = []
            for todayShow in xityShowController.showArray {
                let stringDate = dateFormatter.string(from: todayShow.show.date)
                if stringDate == timeController.todayString {
                    xityShowController.todayShowArray.removeAll(where: {$0 == todayShow})
                    xityShowController.todayShowArray.append(todayShow)
                }
            }
            
            xityShowController.todayShowArray.sort(by: {$0.show.date < $1.show.date})
            self.syncingActionsFinished += 1
            print("*** Collected Today's Shows ***")
        }
        
        let op1 = BlockOperation {
            //Creating Xity Show Data
            let genericBand = Band(name: "No Name")
            let genericBusiness = Business(name: "Not Found", address: "", phoneNumber: 000, website: "")
            print("op3 Started")
            var showArray = showController.showArray.filter({$0.date >= timeController.threeHoursAgo})
            showArray.removeAll(where: {$0.onHold == true})
            
            let businessArray = businessController.businessArray
            let bandArray = bandController.bandArray
            
            for show in showArray {
                
                //This protects against missing bands and missing businesses***
                var  band = bandArray.first(where: {$0.name == show.band})
                if band == nil {
                    band = genericBand
                }
                
                var business = businessArray.first(where: {$0.name == show.venue})
                if business == nil {
                    business = genericBusiness
                }
                
                let xity = XityShow(band: band!, business: business!, show: show)
                xityShowController.showArray.append(xity)
                
            }
            xityShowController.removeDuplicates()
            self.syncingActionsFinished += 1
            print("*** Creating Xity Show Data ***")
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
