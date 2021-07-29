//
//  LoadInitDataViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/14/21.
//

import UIKit
import Firebase

class LoadInitDataViewController: UIViewController {
    
    //Properties
    var todayShowArray: [Show] = []
    var todayVenueArray: [BusinessFullData] = []
    var todayDate = ""
    
    
    var dataActionsFinished = 0 { didSet { if dataActionsFinished == 4 { organizeData() }}}
    
    var bannerAdsSet = false { didSet { updateLoader(from: .BannerAdsLoaded) }}
    
    var cacheShowsSet = false { didSet { updateLoader(from: .ShowsCollected) }}
    var cacheBandsSet = false { didSet { updateLoader(from: .BandsCollected) }}
    var cacheBizSet = false { didSet { updateLoader(from: .BusinessesCollected) }}
    
    var downloadShowsSet = false { didSet { updateLoader(from: .ShowsLoaded) }}
    var downloadBandsSet = false { didSet { updateLoader(from: .BandsLoaded) }}
    var downloadBizSet = false { didSet { updateLoader(from: .BusinessesLoaded) }}
    
    
    var stepFinishedLoading: LoadingScreenInfo?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificatonObservers()
        updateViewController()
        lmDateHandler.checkDateAndGetData()
        
        
        //resetCache
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = false
//        settings.isPersistenceEnabled = true
        
    }
    @IBAction func btn(_ sender: Any) {
        print("****Tapped****")
        //resetCache
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        settings.isPersistenceEnabled = true
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
        todayDate = "August 21, 2021"
    }
    
    private func doneLoading() {
        //print(showController.showArray)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ToDashboard", sender: self)
        }
    }
    
    //MARK: UpdateViews
    private func updateViewController() {
        dateFormatter.dateFormat = dateFormat3
        getTodaysDate()
    }
    
    private func updateLoader(from: LoadingScreenInfo) {
        switch from {
        case .BannerAdsLoaded:
            print("!!!!!!!!\(from)!!!!!!!!")
        case .BannerAdsCollected:
            print("!!!!!!!!\(from)!!!!!!!!")
        case .ShowsLoaded:
            print("!!!!!!!!\(from)!!!!!!!!")
        case .ShowsCollected:
            print("!!!!!!!!\(from)!!!!!!!!")
        case .BusinessesLoaded:
            print("!!!!!!!!\(from)!!!!!!!!")
        case .BusinessesCollected:
            print("!!!!!!!!\(from)!!!!!!!!")
        case .BandsLoaded:
            print("!!!!!!!!\(from)!!!!!!!!")
        case .BandsCollected:
            print("!!!!!!!!\(from)!!!!!!!!")
        }
    }
    
    private func addNotificatonObservers() {
        //Cache Loading Notifications
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotCacheShowData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotCacheBandData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotCacheBusinessData.name, object: nil)
        
        //Database Loading Notifications
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotShowData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotBandData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotBusinessData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.bannerAdsLoaded.name, object: nil)
    }
    
    //@objc Functions
    @objc private func counting(_ notification: NSNotification) {
        dataActionsFinished += 1
        
        if ((notification.userInfo?.contains(where: {$0.value as! LoadingScreenInfo == LoadingScreenInfo.BannerAdsCollected})) != nil) {
            print("***BANNER ADS COLLECTED WORKED FOR LOADING SCREEN PERPOSES****")
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
        }
        
        let bannerAdLoading = BlockOperation {
            bannerAdController.fillArray()
        }
        
        let finalOp = BlockOperation {
            self.doneLoading()
        }
        
        op2.addDependency(op1)
        finalOp.addDependency(op2)
        opQueue.addOperations([op1, op2, finalOp, bannerAdLoading], waitUntilFinished: true)
        
        
    }
    
    
}
