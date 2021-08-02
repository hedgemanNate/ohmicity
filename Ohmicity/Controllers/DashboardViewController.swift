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
    private var weeklyVenueArray: [BusinessFullData] = []
    var weeklyShowArray: [Show] = []
    var favBandsArray: [Band] = []
    
    
    private let bandVenueCellid = "MainCell"
    private let cityCellid = "CityCell"
    
    private var counter = 0
    
    @IBOutlet private weak var getPerksButton: UIButton!
    @IBOutlet private weak var alreadyAccountButton: UIButton!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var topAdView: UIView!
    
    
    //Hidden Elements
    var showsToday: Bool = true
    @IBOutlet private weak var favoritesButton: UIButton!
    @IBOutlet private weak var favoritesCollectionView: UICollectionView!
    @IBOutlet private weak var hiddenSignUpView: UIView!
    @IBOutlet private weak var noShowsView: UIView!
    
    //Collections Views
    @IBOutlet private weak var todayCollectionView: UICollectionView!
    @IBOutlet private weak var citiesCollectionView: UICollectionView!
    @IBOutlet private weak var weeklyCollectionView: UICollectionView!
    @IBOutlet private weak var venueCollectionView: UICollectionView!
    @IBOutlet private weak var bannerAdCollectionView: UICollectionView!
    
    //Buttons
    @IBOutlet private weak var todayButton: UIButton!
    @IBOutlet private weak var citiesButton: UIButton!
    @IBOutlet private weak var weeklyButton: UIButton!
    @IBOutlet private weak var venueButton: UIButton!
    
    //View Backgrounds
    @IBOutlet private weak var recommendView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationObservers()
        updateViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timeController.timer.invalidate()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         //Pass the selected object to the new view controller.
        if segue.identifier == "ToBusiness" {
            let indexPath = todayCollectionView.indexPathsForSelectedItems?.first
            guard let businessVC = segue.destination as? VenueDetailViewController else {return}
            
            businessVC.currentBusiness = businessController.todayVenueArray[indexPath!.row]
            
            timeController.timer.invalidate()
        }
    }
    
    @IBAction func breaker(_ sender: Any) {
        
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
    
    //MARK: Banner Ad
    @objc private func bannerChange() {
        var indexPath = IndexPath(row: counter, section: 0)
        
        //High Count For Infinite Loop: See Banner Ad Collection View
        if counter < 50 {
            self.bannerAdCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            counter += 1
        } else {
            counter = 0
            indexPath = IndexPath(row: 0, section: 0)
            self.bannerAdCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            counter = 1
        }
    }
    
    //MARK: UPDATEVIEWS
    
    private func updateViews() {
        handleHidden()
        showController.removeHolds()
        setupUpCollectionViews()
        
        //UI Adjustments
        getPerksButton.layer.cornerRadius = 5
        
        //Timer
        startTimer()

    }
    
    @objc private func startTimer() {
        DispatchQueue.main.async {
            timeController.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.bannerChange), userInfo: nil, repeats: true)
        }
    }
    
    //MARK: Logic Functions
    
    
    
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
        
        notificationCenter.addObserver(self, selector: #selector(startTimer), name: notifications.modalDismissed.name, object: nil)
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
            //High Count For Infinite Loop: See Banner Ad Collection View & Banner Ad Section
            num = 50
        default:
            num = 4
        }
        
        return num ?? 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var venueCell = BandVenueCollectionViewCell()
        var cityCell = CitiesCollectionViewCell()
        var businessTypeCell = CitiesCollectionViewCell()
        var bannerAdCell = BannerAdBusinessPicsCollectionViewCell()
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
            bannerAdCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerAdCell", for: indexPath) as! BannerAdBusinessPicsCollectionViewCell
            //% for indexpath to allow for infinite loop: See Banner Ad Section
            bannerAdCell.bannerAd = bannerAdController.bannerAdArray[indexPath.row % bannerAdController.bannerAdArray.count]
            return bannerAdCell
            
        default:
            return cell
        }

        //return cell
    }
    
    
    
    
}
