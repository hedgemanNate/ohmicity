//
//  ReloadAllDataViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/25/22.
//

import UIKit
import Firebase
import FirebaseFirestore
import MaterialComponents.MaterialActivityIndicator

class ReloadAllDataViewController: UIViewController {
    //MARK: Properties
    //Loader
    let activityIndicator = MDCActivityIndicator()
    
    var dataActionsFinished = 0 {
        didSet {
//            print("🔄 Data Actions \(dataActionsFinished)")
//            if dataActionsFinished == 4 {
//                print("Actions Finished")
//
//            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAllData()
        setupProgressView()
        startDataProcesses()
    }
    
    @IBAction func breaker(_ sender: Any) {
        
    }
    
}

//MARK: viewDidLoad Functions
extension ReloadAllDataViewController {
    
    private func clearAllData() {
        businessController.businessArray = []
        xityBusinessController.businessArray = []
        
        bandController.bandArray = []
        bandController.bandGroupArray = []
        xityBandController.bandArray = []
        
        showController.showArray = []
        showController.todayShowArray = []
        xityShowController.showArray = []
        xityShowController.weeklyPicksArray = []
        xityShowController.todayShowArray = []
        xityShowController.todayShowResultsArray = []
        xityShowController.xityShowSearchArray = []
        
        notificationCenter.post(notifications.reloadAllData)
    }
}

//MARK: UpdateViews
extension ReloadAllDataViewController {
    private func updateViews() {
        timeController.setTime()
        //setTime(enterTime) format July 31, 2021
    }
}

//MARK: Progress Bar Functions
extension ReloadAllDataViewController {
    private func setupProgressView() {
        activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 1)
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.radius = 150
        activityIndicator.cycleColors = [cc.highlightBlue, UIColor.yellow, UIColor.systemPurple, UIColor.green]
        activityIndicator.startAnimating()
    }
}

//MARK: Notifications
extension ReloadAllDataViewController {
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
    
    //MARK: Functions For Notifications
    @objc private func counting(_ notification: NSNotification) {
        switch notification.name {
        
//        case notifications.gotAllBandData.name:
//            dataActionsFinished += 1
//            print("gotAllBandData")
//
//        case notifications.gotAllBusinessData.name:
//            dataActionsFinished += 1
//            print("gotAllBusinessData")
//
//        case notifications.gotAllBusinessAdData.name:
//            dataActionsFinished += 1
//            print("gotAllBusinessAdData")
//
//        case notifications.gotAllShowData.name:
//            dataActionsFinished += 1
//            print("gotAllShowData")
            
        
//        case notifications.gotCacheBandData.name:
//            dataActionsFinished += 1
//            // For Debuging the loader cacheAction += 1
//            print("gotCacheBandData")
//        case notifications.gotCacheBusinessData.name:
//            dataActionsFinished += 1
//            // For Debuging the loader cacheAction += 1
//            print("gotCacheBusinessData")
//        case notifications.gotCacheShowData.name:
//            dataActionsFinished += 1
//            // For Debuging the loader cacheAction += 1
//            print("gotCacheShowData")
//        case notifications.gotCacheBusinessAdData.name:
//           dataActionsFinished += 1
//            // For Debuging the loader cacheAction += 1
//            print("gotCacheBusinessAdData")
//
        
//        case notifications.gotAllBandData.name:
//            dataActionsFinished += 1
//            // For Debuging the loader allDataAction += 1
//            print("gotAllBandData")
//        case notifications.gotAllBusinessAdData.name:
//            dataActionsFinished += 1
//            // For Debuging the loader allDataAction += 1
//            print("gotAllBusinessAdData")
//        case notifications.gotAllBusinessData.name:
//            dataActionsFinished += 1
//            // For Debuging the loader allDataAction += 1
//            print("gotAllBusinessData")
//        case notifications.gotAllShowData.name:
//            dataActionsFinished += 1
//            // For Debuging the loader allDataAction += 1
//            print("gotAllShowData")
        default:
            break
        }
    }
}

//MARK: Gather Data
extension ReloadAllDataViewController {
    
    private func startDataProcesses() {
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        let download = BlockOperation {
            print(1)
            self.downloadRawDataFromDatabase()
            
        }
        
        let fillFromCache = BlockOperation {
            print(2)
            self.fillBandAndShowArrays()
            
        }
        
        let buildXity = BlockOperation {
            print(3)
            self.buildXity()
            
        }
        
        let fillSpecialArrays = BlockOperation {
            self.fillSpecialArrays()
        }

        let checkData = BlockOperation {
            self.checkingData()
        }

        let clearCache = BlockOperation {
            showController.showArray = []
            bandController.bandArray = []
            businessController.businessArray = []
        }
        
        let finalOP = BlockOperation {
            notificationCenter.post(name: Notification.Name(notifications.reloadAllData.name.rawValue), object: nil)
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        opQueue.addOperations([download, fillFromCache, buildXity, fillSpecialArrays, checkData, clearCache, finalOP], waitUntilFinished: false)
    }
    
    
//MARK: Data Processes
    private func downloadRawDataFromDatabase() {
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        let downloadBusiness1 = BlockOperation {
            print(1.1)
            self.getAllBusinesses()//This function fills the Business Array as Well
            
        }
        
        let downloadBand2 = BlockOperation {
            print(1.2)
            self.getAllBands()
        }
        
        let downloadShow3 = BlockOperation {
            print(1.3)
            self.getAllShows()
            
        }
        
        opQueue.addOperations([downloadBusiness1, downloadBand2, downloadShow3], waitUntilFinished: true)
    }
    
    private func fillBandAndShowArrays() {
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        let fillBandArray = BlockOperation {
            bandController.fillBandArrayFromCache()
            print(2.1)
        }
        
        let fillShowArray = BlockOperation {
            while bandController.bandArray.count < 300 {

                if bandController.bandArray.count >= 300 {
                    showController.fillShowArrayFromCache()
                    print("Done")
                    break
                }
            }
            print(2.2)
        }
        
        opQueue.addOperations([fillBandArray, fillShowArray], waitUntilFinished: true)
    }
    
    private func buildXity() {
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        let fillXityShowArray = BlockOperation {
            xityShowController.fillXityShowArray()
            print(3.1 )
        }
        
        let fillXityBandArray = BlockOperation {
            xityBandController.fillXityBandArray()
            print(3.2 )
        }
        
        let fillXityBusinessArray = BlockOperation {
            xityBusinessController.fillXityBusinessArray()
            print(3.3 )
        }
        
        opQueue.addOperations([fillXityShowArray, fillXityBandArray, fillXityBusinessArray], waitUntilFinished: true)
    }
    
    private func fillSpecialArrays() {
        //Today Shows
        dateFormatter.dateFormat = timeController.monthDayYear
        for todayShow in xityShowController.showArray {
            let stringDate = dateFormatter.string(from: todayShow.show.date)
            if stringDate == timeController.todayString {
                xityShowController.todayShowArray.append(todayShow)
            }
        }
        
        let set = Set(xityShowController.todayShowArray)
        xityShowController.todayShowArray = Array(set)
        xityShowController.todayShowArray.sort(by: {$0.show.date < $1.show.date})
        
        //Weekly Picks
        xityShowController.getWeeklyPicks()
        
        //Favorites Array
        FavoriteController.generateFavorites()
    }
    
    private func checkingData() {
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        let checkingBands = BlockOperation {
            if Float(xityBandController.bandArray.count) < Float(bandController.bandArray.count) * 0.90 {
                NSLog("Xity Band data is missing: Xity Band \(xityBandController.bandArray.count) vs. Raw Band \(bandController.bandArray.count)")
            }
        }
        
        let checkingBusiness = BlockOperation {
            if Float(xityBusinessController.businessArray.count) < Float(businessController.businessArray.count) * 0.90 {
                NSLog("Xity Business data is missing: Xity Business \(xityBusinessController.businessArray.count) vs. Raw Business \(businessController.businessArray.count)")
            }
        }
        
        let checkingShows = BlockOperation {
            if Float(xityShowController.showArray.count) < Float(showController.showArray.count) * 0.90 {
                NSLog("Xity Show Data is missing: Xity Show \(xityShowController.showArray.count) vs. Raw Show \(showController.showArray.count)")
            }
        }
        
        opQueue.addOperations([checkingBands, checkingBusiness, checkingShows], waitUntilFinished: true)
    }
}


//MARK: Firebase Functions
extension ReloadAllDataViewController {
    
    private func getAllBands() {
        FireStoreReferenceManager.bandDataPath.getDocuments { snapShot, error in
            if let err = error {
                NSLog(err.localizedDescription)
            } else {
                for bandGroup in snapShot!.documents {
                    let result = Result {
                        try bandGroup.data(as: GroupOfProductionBands.self)
                    }
                    switch result {
                    case .success(let bandGroup):
                        if let bandGroup = bandGroup {
                            bandController.bandGroupArray.append(bandGroup)
                        }
                    case .failure(let error):
                        NSLog(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func getAllBusinesses() {
        FireStoreReferenceManager.businessFullDataPath.getDocuments { snapShot, error in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                for business in snapShot!.documents {
                    let result = Result {
                        try business.data(as: Business.self)
                    }
                    switch result {
                    case .success(let business):
                        if let business = business {
                            businessController.businessArray.append(business)
                        } else {
                            NSLog("Band Group is nil")
                        }
                    case .failure(let error):
                        NSLog(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func getAllShows() {
        FireStoreReferenceManager.showDataPath.document(ProductionShowController.allShows.allProductionShowsID).getDocument { snapShot, error in
            let result = Result {
                try snapShot?.data(as: AllProductionShows.self)
            }
            switch result {
            case .success(let success):
                if let allShows = success {
                    ProductionShowController.allShows = allShows
                } else {
                    NSLog("Production Shows were not found: getAllShowData")
                }
            case .failure(let failure):
                NSLog(failure.localizedDescription)
            }
        }
    }
}
