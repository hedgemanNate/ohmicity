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
    private var weeklyVenueArray: [Business] = []
    var weeklyShowArray: [Show] = []
    
    
    private let bandVenueCellid = "MainCell"
    private let cityCellid = "CityCell"
    
    //Timer
    var timer = Timer()
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
    var searchCollectionViewTapped = 0
    
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    
    @IBAction func breaker(_ sender: Any) {
        
    }
}


//MARK: ---- Functions ----
extension DashboardViewController {
    //UI Functions
    private func handleHidden() {
        if currentUserController.currentUser == nil {
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
        let shownPath = bannerAdCollectionView.indexPathsForVisibleItems
        let currentPath = shownPath.first
    
        var indexPath = IndexPath(row: currentPath!.row + 1, section: 0)
        
        //High Count For Infinite Loop: See Banner Ad Collection View
        if currentPath!.row < 25 {
            self.bannerAdCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        } else {
            indexPath = IndexPath(row: 0, section: 0)
            self.bannerAdCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    @objc private func startTimer() {
        timer.invalidate()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.bannerChange), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func endTimer() {
        timer.invalidate()
    }
    
    //MARK: UPDATEVIEWS
    @objc private func updateViews() {
        handleHidden()
        showController.removeHolds()
        setupUpCollectionViews()
        
        //UI Adjustments
        getPerksButton.layer.cornerRadius = 5
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(organizeData), for: .valueChanged)

    }
    
    //MARK: Logic Functions
    @objc private func getFavorites() {
        if currentUserController.currentUser != nil {
            currentUserController.favArray = []
            for string in currentUserController.currentUser!.favoriteBusinesses {
                guard let business = businessController.businessArray.first(where: {$0.venueID == string}) else {return}
                currentUserController.favArray.append(business)
            }
        }
        favoritesCollectionView.reloadData()
    }
    
    //----- Refresh Data Start -----
    @objc private func organizeData() {
        //Collected Weekly Picks
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        //Check Database
        let checkDataBase = BlockOperation {
            lmDateHandler.checkDateAndGetData()
        }
        
        //Gathering Xity Band And Business Data
        let op2 = BlockOperation {
            xityBandController.fillXityBandArray()
            xityBusinessController.fillXityBusinessArray()
            print("*** Creating Xity Band And Business Data ***")
        }
        
        //Gathering Weekly Picks
        let op3 = BlockOperation {
            xityShowController.getWeeklyPicks()
            //xityShowController.weeklyPicksArray.sort(by: {$0.show.date < $1.show.date})
            
            print("*** Collected Weekly Picks ***")
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
            xityShowController.todayShowArray.sort(by: {$0.show.date < $1.show.date})
            print("*** Collected Today's Shows ***")
        }
        
        let op1 = BlockOperation {
            //Creating Xity Show Data
            let genericBand = Band(name: "No Name")
            let genericBusiness = Business(name: "Not Found", address: "", phoneNumber: 000, website: "")
            print("op3 Started")
            let showArray = showController.showArray.filter({$0.date >= timeController.twoHoursAgo})
            
            let businessArray = businessController.businessArray
            let bandArray = bandController.bandArray
            
            for show in showArray {
                print(show.band)
                
                //This protects against missing bands and missing businesses***
                var  band = bandArray.first(where: {$0.name == show.band})
                if band == nil {
                    band = genericBand
                }
                
                var business = businessArray.first(where: {$0.name == show.venue})
                if business == nil {
                    business = genericBusiness
                }
                //******
                
                let xity = XityShow(band: band!, business: business!, show: show)
                xityShowController.showArray.append(xity)
                
            }
            print("*** Creating Xity Show Data ***")
        }
        
        
        let finalOp = BlockOperation {
            DispatchQueue.main.async {
                self.todayCollectionView.reloadData()
                self.weeklyCollectionView.reloadData()
                self.scrollView.refreshControl?.endRefreshing()
            }
        }
        
        op1.addDependency(checkDataBase)
        op2.addDependency(op1)
        op3.addDependency(op2)
        op4.addDependency(op3)
        opQueue.addOperations([checkDataBase, op1, op2, op3, op4, finalOp], waitUntilFinished: true)
        
        
    }
    //----- Refresh Data End -----
    
    
    //MARK: Setup CollectionViews
    private func setupUpCollectionViews() {
        
        citiesCollectionView.delegate = self
        citiesCollectionView.dataSource = self
        citiesCollectionView.showsHorizontalScrollIndicator = false
        citiesCollectionView.reloadData()
        
        todayCollectionView.delegate = self
        todayCollectionView.dataSource = self
        todayCollectionView.showsHorizontalScrollIndicator = false
        todayCollectionView.reloadData()
        
        venueCollectionView.delegate = self
        venueCollectionView.dataSource = self
        venueCollectionView.showsHorizontalScrollIndicator = false
        venueCollectionView.reloadData()
        
        bannerAdCollectionView.delegate = self
        bannerAdCollectionView.dataSource = self
        bannerAdCollectionView.showsHorizontalScrollIndicator = false
        bannerAdCollectionView.reloadData()
        
        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.showsHorizontalScrollIndicator = false
        getFavorites()
        
        weeklyCollectionView.delegate = self
        weeklyCollectionView.dataSource = self
        weeklyCollectionView.showsHorizontalScrollIndicator = false
        weeklyCollectionView.reloadData()
    }
    
    
    private func notificationObservers() {
        //Hide Views
        notificationCenter.addObserver(self, selector: #selector(updateViews), name: notifications.userAuthUpdated.name, object: nil)
        
        //Scroll To Top
        notificationCenter.addObserver(self, selector: #selector(scrollToTop), name: notifications.scrollToTop.name, object: nil)
        
        //Banner SlideShow Start
        notificationCenter.addObserver(self, selector: #selector(startTimer), name: notifications.modalDismissed.name, object: nil)
        
        //Favorites
        notificationCenter.addObserver(self, selector: #selector(getFavorites), name: notifications.userFavoritesUpdated.name, object: nil)
        
        //Background
        notificationCenter.addObserver(self, selector: #selector(endTimer), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    //MARK: ---- Functions End ----
}


//MARK: Collection View Protocols
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        
        switch collectionView {
        case bannerAdCollectionView:
            size = CGSize(width: width, height: height)
            return size
        case todayCollectionView:
            size = CGSize(width: 155, height: height)
            return size
        case citiesCollectionView:
            size = CGSize(width: 155, height: height)
            return size
        case weeklyCollectionView:
            size = CGSize(width: 155, height: height)
            return size
        case venueCollectionView:
            size = CGSize(width: 155, height: height)
            return size
        case favoritesCollectionView:
            size = CGSize(width: 155, height: height)
            return size
        case weeklyCollectionView:
            size = CGSize(width: 155, height: height)
            return size
        default:
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case bannerAdCollectionView:
            //High Count For Infinite Loop: See Banner Ad Collection View & Banner Ad Section
            return 50
        case todayCollectionView:
            return xityShowController.todayShowArray.count
        case citiesCollectionView:
            return businessController.citiesArray.count
        case venueCollectionView:
            return businessController.businessTypeArray.count
        case favoritesCollectionView:
            return currentUserController.favArray.count
        case weeklyCollectionView:
            return xityShowController.weeklyPicksArray.count
        default:
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var venueCell = BandVenueCollectionViewCell()
        var xityPickCell = BandVenueCollectionViewCell()
        var cityCell = CitiesCollectionViewCell()
        var businessTypeCell = CitiesCollectionViewCell()
        var bannerAdCell = BannerAdBusinessPicsCollectionViewCell()
        let cell = UICollectionViewCell()
    
        
        switch collectionView {
        case bannerAdCollectionView:
            bannerAdCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerAdCell", for: indexPath) as! BannerAdBusinessPicsCollectionViewCell
            //% for indexpath to allow for infinite loop: See Banner Ad Section
            bannerAdCell.bannerAd = bannerAdController.bannerAdArray[indexPath.row % bannerAdController.bannerAdArray.count]
            return bannerAdCell
            
        case todayCollectionView:
            venueCell = collectionView.dequeueReusableCell(withReuseIdentifier: bandVenueCellid, for: indexPath) as! BandVenueCollectionViewCell
            venueCell.venue = xityShowController.todayShowArray[indexPath.row].business
            return venueCell
            
        case citiesCollectionView:
            cityCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as! CitiesCollectionViewCell
            cityCell.city = businessController.citiesArray[indexPath.row]
            return cityCell
            
        case venueCollectionView:
            businessTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessTypeCell", for: indexPath) as! CitiesCollectionViewCell
            businessTypeCell.businessType = businessController.businessTypeArray[indexPath.row]
            return businessTypeCell
            
        case favoritesCollectionView:
            venueCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! BandVenueCollectionViewCell
            venueCell.venue = currentUserController.favArray[indexPath.row]
            return venueCell
        case weeklyCollectionView:
            xityPickCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyCell", for: indexPath) as! BandVenueCollectionViewCell
            xityPickCell.xityPick = xityShowController.weeklyPicksArray[indexPath.row]
            return xityPickCell
        default:
            return cell
        }

        //return cell
    }
    
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         //Pass the selected object to the new view controller.
        if segue.identifier == "FromToday" {
            timer.invalidate()
            let indexPath = todayCollectionView.indexPathsForSelectedItems?.first
            guard let businessVC = segue.destination as? VenueDetailViewController else {return}
            let selected = xityShowController.todayShowArray[indexPath!.row]
            let business = selected.business
            let xityBusiness = xityBusinessController.businessArray.first(where: {$0.business == business})
            businessVC.xityBusiness = xityBusiness
            businessVC.featuredShow = selected
            
        }
        
        if segue.identifier == "FromFav" {
            timer.invalidate()
            let indexPath = favoritesCollectionView.indexPathsForSelectedItems?.first
            guard let businessVC = segue.destination as? VenueDetailViewController else {return}
            let business = currentUserController.favArray[indexPath!.row]
            
            let xityBusiness = xityBusinessController.businessArray.first(where: {$0.business == business})
            xityBusiness?.xityShows.removeAll(where: {$0.show.date < timeController.twoHoursAgo})
            
            businessVC.featuredShow = xityBusiness?.xityShows.first
            businessVC.xityBusiness = xityBusiness!
        }
        
        if segue.identifier == "FromXityPick" {
            timer.invalidate()
            let indexPath = weeklyCollectionView.indexPathsForSelectedItems?.first
            guard let businessVC = segue.destination as? VenueDetailViewController else {return}
            let pick = xityShowController.weeklyPicksArray[indexPath!.row]
            let xityBusiness = xityBusinessController.businessArray.first(where: {$0.business == pick.business})
            businessVC.xityBusiness = xityBusiness
            businessVC.featuredShow = pick
            
        }
    }
}
