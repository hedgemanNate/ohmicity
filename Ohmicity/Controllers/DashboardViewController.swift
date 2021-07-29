//
//  DashboardViewController.swift
//  Ohmicity
//
//  Created by Nate Hedgeman on 5/6/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DashboardViewController: UIViewController {
    
    
    //Properties
    var todayVenueArray: [BusinessFullData] = []
    var todayBandArray: [Band] = []
    var todayShowArray: [Show] = []
    var weeklyVenueArray: [BusinessFullData] = []
    var weeklyShowArray: [Show] = []
    var favBandsArray: [Band] = []
    
    var todayDate = ""
    let bandVenueCellid = "MainCell"
    let cityCellid = "CityCell"
    
    @IBOutlet weak var getPerksButton: UIButton!
    @IBOutlet weak var alreadyAccountButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topAdView: UIView!
    
    
    //Hidden Elements
    var showsToday: Bool = true
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    @IBOutlet weak var hiddenSignUpView: UIView!
    @IBOutlet weak var noShowsView: UIView!
    
    //Collections Views
    @IBOutlet weak var todayCollectionView: UICollectionView!
    @IBOutlet weak var citiesCollectionView: UICollectionView!
    @IBOutlet weak var weeklyCollectionView: UICollectionView!
    @IBOutlet weak var venueCollectionView: UICollectionView!
    @IBOutlet weak var bannerAdCollectionView: UICollectionView!
    
    //Buttons
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var citiesButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var venueButton: UIButton!
    
    //View Backgrounds
    @IBOutlet weak var recommendView: UIView!
    
    //MARK: OPERATIONS
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationObservers()
        updateViews()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func breaker(_ sender: Any) {
        
        ref.fireDataBase.clearPersistence { err in
            if let err = err {
                NSLog("***Firestore: Cache Not Cleared***: \(err)")
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let stringDate = dateFormatter.string(from: showController.showArray[124].date)
        
        print(stringDate)
        print(todayDate)
        
    }
}


//MARK: Functions
extension DashboardViewController {
    //UI Functions
    @objc private func handleHidden() {
        if Auth.auth().currentUser == nil {
            favoritesButton.isHidden = true
            favoritesCollectionView.isHidden = true
            hiddenSignUpView.isHidden = false
        } else {
            favoritesButton.isHidden = false
            favoritesCollectionView.isHidden = false
            hiddenSignUpView.isHidden = true
        }
        
    }
    
    @objc private func scrollToTop() {
        scrollView.scrollToTop(animated: true)
    }
    
    
    //MARK: UPDATEVIEWS
    private func updateViews() {
        self.getTodaysDate()
        //self.getCollectionData()
        handleHidden()
        setupUpCollectionViews()

    }
    
    //MARK: Logic Functions
    private func getTodaysDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        todayDate = dateFormatter.string(from: Date())
    }
    
    private func getCollectionData() {
        //MARK: Today Data
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        let op1 = BlockOperation {
            for show in showController.showArray {
                let stringDate = dateFormatter.string(from: show.date)
                
                if stringDate == self.todayDate {
                    self.todayShowArray.append(show)
                }
            }
        }
        
        let op2 = BlockOperation {
            for show in self.todayShowArray {
                for venue in businessController.businessArray { 
                    if show.venue == venue.name {
                        self.todayVenueArray.append(venue)
                    }
                }
            }
            
            for show in self.todayShowArray {
                for band in bandController.bandArray {
                    if show.band == band.name {
                        self.todayBandArray.append(band)
                    }
                }
            }
        }
        
        op2.addDependency(op1)
        opQueue.addOperations([op1, op2], waitUntilFinished: false)
        
        //End Today Data
    }
    
    
    //MARK: Setup CollectionViews
    private func setupUpCollectionViews() {
        
        citiesCollectionView.delegate = self
        citiesCollectionView.dataSource = self
        citiesCollectionView.showsHorizontalScrollIndicator = false
        
        todayCollectionView.delegate = self
        todayCollectionView.dataSource = self
        todayCollectionView.showsHorizontalScrollIndicator = false
        
        venueCollectionView.delegate = self
        venueCollectionView.dataSource = self
        venueCollectionView.showsHorizontalScrollIndicator = false
        
        bannerAdCollectionView.delegate = self
        bannerAdCollectionView.dataSource = self
        bannerAdCollectionView.showsHorizontalScrollIndicator = false
    }
    
    
    private func notificationObservers() {
        //Hide Views
        notificationCenter.addObserver(self, selector: #selector(handleHidden), name: notifications.userAuthUpdated.name, object: nil)
        
        //Scroll To Top
        notificationCenter.addObserver(self, selector: #selector(scrollToTop), name: notifications.scrollToTop.name, object: nil)
    }
}


//MARK: Collection View Protocols
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var num: Int?
        
        switch collectionView {
        case todayCollectionView:
            num = businessController.todayVenueArray.count
        case citiesCollectionView:
            num = businessController.citiesArray.count
        case venueCollectionView:
            num = businessController.businessTypeArray.count
        case bannerAdCollectionView:
            num = bannerAdController.bannerAdArray.count
        default:
            num = 4
        }
        
        return num ?? 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var venueCell = BandVenueCollectionViewCell()
        var cityCell = CitiesCollectionViewCell()
        var businessTypeCell = CitiesCollectionViewCell()
        var bannerAdCell = BannerAdCollectionViewCell()
        let cell = UICollectionViewCell()
    
        
        switch collectionView {
        case todayCollectionView:
            venueCell = collectionView.dequeueReusableCell(withReuseIdentifier: bandVenueCellid, for: indexPath) as! BandVenueCollectionViewCell
            venueCell.venue = businessController.todayVenueArray[indexPath.row]
            return venueCell
            
        case citiesCollectionView:
            cityCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as! CitiesCollectionViewCell
            cityCell.city = businessController.citiesArray[indexPath.row]
            return cityCell
            
        case venueCollectionView:
            businessTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessTypeCell", for: indexPath) as! CitiesCollectionViewCell
            businessTypeCell.type = businessController.businessTypeArray[indexPath.row]
            return businessTypeCell
            
        case bannerAdCollectionView:
            bannerAdCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerAdCell", for: indexPath) as! BannerAdCollectionViewCell
            bannerAdCell.bannerAd = bannerAdController.bannerAdArray[indexPath.row]
            return bannerAdCell
            
        default:
            return cell
        }

        //return cell
    }
    
    
    
    
}
