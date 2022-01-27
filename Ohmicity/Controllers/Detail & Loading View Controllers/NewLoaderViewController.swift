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
    
    //StepComplete
    var gotRawShowData = false {didSet{}}
    var gotRawData = false
    
    //Loader
    let activityIndicator = MDCActivityIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressView()
        processData()
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
    //MARK: Queue Functions
    
    private func processData() {
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        let download = BlockOperation {
            self.download()
        }
        
        let fillArrays = BlockOperation {
            self.fillArrays()
        }
        
        let buildXity = BlockOperation {
            
        }
        
        let removeCache = BlockOperation {
            
        }
        
        removeCache.addDependency(buildXity)
        buildXity.addDependency(fillArrays)
        fillArrays.addDependency(download)
        
        opQueue.addOperations([download, fillArrays], waitUntilFinished: true)
    }
    
    private func download() {
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        let getRawBands = BlockOperation { [self] in
            self.getRawBandData()
            guard let rawBandCount = rawBandCount else {return}
            while bandController.bandGroupArray.count < rawBandCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    //WAIT
                }
            }
        }
        
        let getRawVenues = BlockOperation {
            self.getRawVenueData()
        }
        
        let getRawShows = BlockOperation {
            self.getRawShowData()
            
        }
        
        let getBanners = BlockOperation {
            self.getAllBannerAdsData()
        }
        
        getBanners.addDependency(getRawShows)
        getRawShows.addDependency(getRawVenues)
        getRawVenues.addDependency(getRawBands)
        
        opQueue.addOperations([getRawBands, getRawVenues, getRawShows, getBanners], waitUntilFinished: true)
    }
    
    private func fillArrays() {
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        let fillShowArray = BlockOperation {
            self.fillShowArray()
        }
        
        let fillBandArray = BlockOperation {
            self.fillBandArray()
        }
        
        fillBandArray.addDependency(fillShowArray)
        
        opQueue.addOperations([fillShowArray, fillBandArray], waitUntilFinished: true)
    }
}

//MARK: Download Functions
extension NewLoaderViewController {
    
    private func getRawShowData() {
        FireStoreReferenceManager.showDataPath.document("EB7BD27C-15EA-43A5-866A-BF6883D0DD67").getDocument { snap, _ in
            do {
                try ProductionShowController.allShows = snap!.data(as: AllProductionShows.self)!
            } catch let error {
                NSLog(error.localizedDescription)
            }
        }
    }
    
    
    private func getRawBandData() {
        FireStoreReferenceManager.bandDataPath.getDocuments { snapShot, error in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                self.rawBandCount = snapShot?.documents.count
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
    
    private func getRawVenueData() {
        FireStoreReferenceManager.venueDataPath.getDocuments { snap, error in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                for business in snap!.documents {
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
    
    func getAllBannerAdsData() {
        
        func removeNonPublished() {
            businessBannerAdController.businessAdArray.removeAll(where: {$0.isPublished == false})
            businessBannerAdController.businessAdArray.removeAll(where: {$0.endDate <= Date()})
        }
        
        FireStoreReferenceManager.businessBannerAdDataPath.getDocuments() { (querySnapshot, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            } else {
                for businessAd in querySnapshot!.documents {
                    let result = Result {
                        try businessAd.data(as: BusinessBannerAd.self)
                    }
                    switch result {
                    case .success(let businessAd):
                        if let businessAd = businessAd {
                            businessBannerAdController.businessAdArray.removeAll(where: {$0 == businessAd})
                            businessBannerAdController.businessAdArray.append(businessAd)
                        } else {
                            NSLog("Show data was nil")
                        }
                    case .failure(let error):
                        NSLog("Error decoding businessAd: \(error)")
                    }
                }
                removeNonPublished()
            }
        }
    }
}

//MARK: Fill Arrays Functions
extension NewLoaderViewController {
    private func fillShowArray() {
        for show in ProductionShowController.allShows.shows {
            
            let newShow = Show(showID: show.showID, band: show.band, venue: show.venue, bandDisplayName: show.bandDisplayName, date: show.date)
            
            showController.showArray.append(newShow)
        }
        showController.showArray.sort(by: {$0.date < $1.date})
    }
    
    private func fillBandArray() {
        for group in bandController.bandGroupArray {
            for band in group.bands {
                let newBand = Band(singleBand: band)
                bandController.bandArray.append(newBand)
            }
        }
        bandController.bandArray.sort(by: {$0.name < $1.name})
    }
}
