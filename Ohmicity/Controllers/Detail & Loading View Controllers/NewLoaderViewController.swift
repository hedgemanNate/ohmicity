//
//  NewLoaderViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/26/22.
//

import UIKit
import Firebase
import FirebaseFirestore
import MaterialComponents.MaterialActivityIndicator

class NewLoaderViewController: UIViewController {
    
    //Properties
    var rawBandCount: Int?
    let workQueue = DispatchQueue.self
    
    //Order
    
    //StepComplete
    var gotRawShowData = false {didSet{}}
    var gotRawData = false
    
    //Loader
    let activityIndicator = MDCActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DevelopmentSettingsController.loadDevData()
        DevelopmentSettingsController.setDatabase()
        print(DevelopmentSettingsController.devSettings.database)
        setupProgressView()
        startWork()
    }
    
    
    @IBAction func breaker(_ sender: Any) {
        
    }
}

extension NewLoaderViewController {
    //MARK: Progress Bar Functions
    private func setupProgressView() {
        activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 1)
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.radius = 150
        activityIndicator.cycleColors = [cc.highlightBlue, UIColor.yellow, UIColor.systemPurple, UIColor.green]
        activityIndicator.startAnimating()
    }
}

extension NewLoaderViewController {
    
    //MARK: PreDownload Work
    private func startWork() {
        let group = DispatchGroup()
        
        DispatchQueue.global(qos: .default).sync {
            group.enter()
            currentUserController.assignCurrentUser()
            
            //Notifications
            NotifyCenter.addObserver(self, selector: #selector(lostNetworkConnection), name: Notifications.lostConnection.name, object: nil)
            
            NotifyCenter.addObserver(self, selector: #selector(forceUpdate), name: Notifications.forceUpdate.name, object: nil)
            group.leave()
            
        
            group.enter()
            CheckForUpdateController.checkIfUpdateIsAvailable()
            group.leave()
            
            
            timeController.setTime()
            
            
            
            group.notify(queue: .global()) { [self] in
                self.downloadData()
            }
        }
    }
    
    @objc private func lostNetworkConnection() {
        NSLog("No Connection 📶📶📶📶 ")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "NetworkConnectionSegue", sender: self)
        }
    }
    
    //MARK: Start Download
    private func downloadData() {
        print("Download Started")
        let group = DispatchGroup()
        
        DispatchQueue.global(qos: .default).sync {
            group.enter()
            FireStoreReferenceManager.showDataPath.document("EB7BD27C-15EA-43A5-866A-BF6883D0DD67").getDocument(source: .default) { snap, err in
                if let err = err {
                    NSLog(err.localizedDescription)
                } else {
                    ProductionShowController.allShows = try! snap!.data(as: AllProductionShows.self)!
                    print("Got Shows")
                    group.leave()
                }
            }
            
            group.enter()
            FireStoreReferenceManager.bandDataPath.getDocuments(source: .default) { snap, err in
                if let err = err {
                    NSLog(err.localizedDescription)
                } else {
                    ProductionBandController.bandGroupArray = snap!.documents.compactMap({ bandGroups in
                        try? bandGroups.data(as: GroupOfProductionBands.self)
                    })
                    print("Got Bands")
                    group.leave()
                }
            }
            
            group.enter()
            FireStoreReferenceManager.venueDataPath.getDocuments(source: .default) { snap, err in
                if let err = err {
                    NSLog(err.localizedDescription)
                } else {
                    BusinessController.businessArray = snap!.documents.compactMap({ venues in
                        try? venues.data(as: Business.self)
                    })
                    print("Got Venues")
                    group.leave()
                }
            }
            
            
            group.enter()
            FireStoreReferenceManager.bannerDataPath.getDocuments(source: .default) { snap, err in
                if let err = err {
                    NSLog(err.localizedDescription)
                } else {
                    BusinessBannerAdController.businessAdArray = snap!.documents.compactMap({ ads in
                        try? ads.data(as: BusinessBannerAd.self)
                    })
                    print("Got Ads")
                    BusinessBannerAdController.removeNonPublished()
                    group.leave()
                }
            }
            
            group.notify(queue: .global()) { [self] in
                self.fillArrays()
            }
        }
    }
    
    //MARK: Fill Arrays
    private func fillArrays() {
        print("Filling Arrays")
        let group = DispatchGroup()
        
        group.enter()
        for show in ProductionShowController.allShows.shows {
            let newShow = Show(singleShow: show)
            ShowController.showArray.append(newShow)
        }
        print("Shows Filled")
        group.leave()
        
        group.enter()
        for bandGroup in ProductionBandController.bandGroupArray {
            for band in bandGroup.bands {
                let newBand = Band(singleBand: band)
                BandController.bandArray.append(newBand)
            }
        }
        print("Bands Filled")
        group.leave()
        
        group.notify(queue: .global()) {
            self.buildXityShows()
        }
    }
    //MARK: Xity Shows
    private func buildXityShows() {
        print("Building Xity")
        let group = DispatchGroup()
        
        group.enter()
        for show in ShowController.showArray {
            guard let band = BandController.bandArray.first(where: {$0.bandID == show.band}) else {continue}
            guard let venue = BusinessController.businessArray.first(where: {$0.venueID == show.venue}) else {continue}
            let xityShow = XityShow(band: band, business: venue, show: show)
            XityShowController.showArray.append(xityShow)
        }
        print("Shows Built")
        group.leave()
        
        group.notify(queue: .global()) {
            self.buildXityBands()
        }
    }
    
    //MARK: Xity Bands
    private func buildXityBands() {
        let group = DispatchGroup()
        
        group.enter()
        for band in BandController.bandArray {
            let _ = XityBand(band: band)
        }
        print("Bands Built")
        group.leave()
        
        group.notify(queue: .global()) {
            self.buildXityVenues()
        }
    }
    
    //MARK: Xity Venues
    private func buildXityVenues() {
        let group = DispatchGroup()
        
        group.enter()
        for venue in BusinessController.businessArray {
            let _ = XityBusiness(venue: venue)
        }
        print("Venues Built")
        group.leave()
        
        group.notify(queue: .global()) {
            self.buildTodayShows()
        }
    }
    
    //MARK: Today
    private func buildTodayShows() {
        let group = DispatchGroup()
        
        group.enter()
        dateFormatter.dateFormat = timeController.monthDayYear
        for todayShow in XityShowController.showArray {
            let stringDate = dateFormatter.string(from: todayShow.show.date)
            if stringDate == timeController.todayString {
                XityShowController.todayShowArray.append(todayShow)
            }
        }
        print("Today Built")
        group.leave()
        
        group.notify(queue: .global()) {
            self.buildWeeklyPicks()
        }
    }
    
    //MARK: Weekly
    private func buildWeeklyPicks() {
        let group = DispatchGroup()
        
        group.enter()
        let monday = Date().next(.monday)
        
        var lowFiltered = [XityShow]()
        var theWeekFiltered = [XityShow]()
        
        let op1 = BlockOperation {
            lowFiltered = XityShowController.showArray.filter({$0.show.date > timeController.threeHoursAgo})
            print("******lowFiltered")
        }
        
        let op2 = BlockOperation {
            theWeekFiltered = lowFiltered.filter({$0.show.date < monday})
            print("******theWeekFiltered")
            print(monday)
        }
        
        let op3 = BlockOperation {
            let mid = theWeekFiltered.filter({$0.show.ohmPick == true})
            XityShowController.weeklyPicksArray = mid.sorted(by: {$0.show.date < $1.show.date})
            print("******Xity Picks!")
        }
        
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        op3.addDependency(op2)
        op2.addDependency(op1)
        opQueue.addOperations([op1, op2, op3], waitUntilFinished: true)
        
        print("Weeks Built")
        group.leave()
        
        group.notify(queue: .global()) {
            self.clearCache()
        }
    }
    
    //MARK: Clear
    private func clearCache() {
        print("Clearing Cache")
        ShowController.showArray = []
        ProductionShowController.allShows = AllProductionShows(shows: [SingleProductionShow]())
        
        BandController.bandArray = []
        ProductionBandController.bandGroupArray = []
        
        BusinessController.businessArray = []
        
        NotifyCenter.removeObserver(self, name: Notifications.lostConnection.name, object:nil )
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ToDashboard", sender: self)
        }
    }
    
    //MARK: ForceUpdate
    @objc private func forceUpdate() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ForceUpdateSegue", sender: self)
        }
    }
}
