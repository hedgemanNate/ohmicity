//
//  DashboardViewController.swift
//  Ohmicity
//
//  Created by Nate Hedgeman on 5/6/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import GoogleMobileAds

class DashboardViewController: UIViewController {
    
    
    //Properties
    let todaySegue = "FromToday"
    let xityPickSegue = "FromXityPick"
    let venueFavSegue = "VenueFromFav"
    let bandFavSegue = "BandFromFav"
    let dealsSoonSegue = "DealsComingSoonSegue"
    
    var sharedIndexPath = IndexPath()
    
    //Banner
    var timer = Timer()
    
    //Feature Access Properties
    var halfTodayShows = [XityShow]()
    @IBOutlet weak var seeAllDataDetailLabel: UILabel!
    
    //Not Logged In
    @IBOutlet private weak var getPerksButton: UIButton!
    @IBOutlet private weak var alreadyAccountButton: UIButton!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var topAdView: UIView!
    
    //Labels
    @IBOutlet weak var cityFilterLabel: UILabel!
    
    //Recommendation Elements
    @IBOutlet private weak var recommendButton: UIButton!
    
    //Hidden Elements
    @IBOutlet private weak var favoritesButton: UIButton!
    @IBOutlet private weak var favoritesCollectionView: UICollectionView!
    @IBOutlet private weak var hiddenSignUpView: UIView!
    @IBOutlet private weak var noShowsView: UIView!
    
    //Collections Views
    @IBOutlet private weak var todayCollectionView: UICollectionView!
    @IBOutlet private weak var xityExclusivesCollectionView: UICollectionView!
    @IBOutlet private weak var xityPickCollectionView: UICollectionView!
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
    
    //Google Ad Properties
    private var interstitialAd: GADInterstitialAd?
    lazy private var segueToPerform = ""
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackGroundNotificationObservers()
        setUpNotificationObservers()
        createInterstitialAd()
        updateViews()
        DispatchQueue.main.async {
            self.checkDevelopmentStatus()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.tintColor = UIColor.clear
        
        let todayFilter = XityShowController.todayShowResultsArray.filter({$0.show.date >= timeController.threeHoursAgo})
        XityShowController.todayShowResultsArray = todayFilter
        
        let weeklyFilter = XityShowController.weeklyPicksArray.filter({$0.show.date >= timeController.threeHoursAgo})
        XityShowController.weeklyPicksArray = weeklyFilter
        
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        endTimer()
    }
    
    @IBAction func cityFilterButtonTapped(_ sender: Any) {
        let subControl = subscriptionController
        subControl.userFeaturesAvailableCheck(feature: subControl.todayShowFilter, viewController: self) {
            self.performSegue(withIdentifier: "ToCityFilterSegue", sender: self)
        }
    }
    
    @IBAction func breaker(_ sender: Any) {
        
    }
}


//MARK: ---- Functions ----
extension DashboardViewController {
    
    private func checkDevelopmentStatus() {
        if FireStoreReferenceManager.inDevelopment == true {
            self.performSegue(withIdentifier: "WrongDatabase", sender: self)
            //Fix in Helpers/FireStoreReferenceManager
            //set inDevelopment == false
        }
    }
    
    
    //UI Functions
    private func handleHidden() {
        if currentUserController.currentUser == nil {
            weeklyButton.isHidden = true
            xityPickCollectionView.isHidden = true
            hiddenSignUpView.isHidden = false
        } else {
            weeklyButton.isHidden = false
            xityPickCollectionView.isHidden = false
            hiddenSignUpView.isHidden = true
        }
        
        if XityShowController.weeklyPicksArray.count == 0 {
            noShowsView.isHidden = false
        } else {
            noShowsView.isHidden = true
        }
        
    }
    
    @objc private func reloadData() {
        var temp = XityShowController.todayShowResultsArray.filter({$0.show.date > timeController.threeHoursAgo})
        XityShowController.todayShowResultsArray = temp
        temp = []
        
        var week = XityShowController.weeklyPicksArray.filter({$0.show.date > timeController.threeHoursAgo})
        XityShowController.weeklyPicksArray = week
        week = []
        
        DispatchQueue.main.async { [self] in
            self.todayCollectionView.reloadData()
            self.favoritesCollectionView.reloadData()
            self.xityPickCollectionView.reloadData()
            self.bannerAdCollectionView.reloadData()
        
            switch XityShowController.todayShowArrayFilter {
            case .Sarasota:
                cityFilterLabel.text = "~Shows in \(XityShowController.todayShowArrayFilter.rawValue)"
            case .Bradenton:
                cityFilterLabel.text = "~Shows in \(XityShowController.todayShowArrayFilter.rawValue)"
            case .Venice:
                cityFilterLabel.text = "~Shows in \(XityShowController.todayShowArrayFilter.rawValue)"
            case .StPete:
                cityFilterLabel.text = "~Shows in \(XityShowController.todayShowArrayFilter.rawValue)"
            case .Tampa:
                cityFilterLabel.text = "~Shows in \(XityShowController.todayShowArrayFilter.rawValue)"
            case .Ybor:
                cityFilterLabel.text = "~Shows in \(XityShowController.todayShowArrayFilter.rawValue)"
            case .All:
                cityFilterLabel.text = "~Filter Shows By City"
            }
        }
    }
    
    @objc private func scrollToTop() {
        scrollView.scrollToTop(animated: true)
    }
    
    //MARK: Banner Ad
    @objc private func bannerChange() {
        let shownPath = bannerAdCollectionView.indexPathsForVisibleItems
        guard let currentPath = shownPath.first else {return}
    
        var indexPath = IndexPath(row: currentPath.row + 1, section: 0)
        
        //High Count For Infinite Loop: See Banner Ad Collection View
        if currentPath.row < 25 {
            DispatchQueue.main.async {
                self.bannerAdCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            
        } else {
            indexPath = IndexPath(row: 0, section: 0)
            DispatchQueue.main.async {
                self.bannerAdCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    @objc private func startTimer() {
        timer.invalidate()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.bannerChange), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func endTimer() {
        DispatchQueue.main.async {
            self.timer.invalidate()
        }
    }
    
    //MARK: UPDATEVIEWS
    @objc private func updateViews() {
        //userAdController.setUpAdsAndFeaturesForUser()
        handleHidden()
        ShowController.removeHolds()
        setupUpCollectionViews()
        
        //UI Adjustments
        getPerksButton.layer.cornerRadius = 5
        cityFilterLabel.text = "~Filter Off"
        
        if subscriptionController.seeAllData == false && currentUserController.currentUser == nil {
            if halfTodayShows.count <= 4 {
                //seeAllDataDetailLabel.text = "See all shows with any Xity Pass"
            } else {
                //seeAllDataDetailLabel.text = "See All \(halfTodayShows.count) shows with any Xity Pass"
            }
            
        } else if subscriptionController.seeAllData == true {
            seeAllDataDetailLabel.text = " "
        }
        
        
        //Recommendation View
        if currentUserController.currentUser == nil {
            recommendButton.isEnabled = false
            recommendButton.setTitle("Sign In To Recommend", for: .disabled)
        } else {
            recommendButton.isEnabled = true
            recommendButton.setTitle("Recommend", for: .normal)
        }

    }
    
    //MARK: Setup CollectionViews
    private func setupUpCollectionViews() {
        
        xityExclusivesCollectionView.delegate = self
        xityExclusivesCollectionView.dataSource = self
        xityExclusivesCollectionView.showsHorizontalScrollIndicator = false
        xityExclusivesCollectionView.reloadData()
        
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
        FavoriteController.generateFavorites()
        
        xityPickCollectionView.delegate = self
        xityPickCollectionView.dataSource = self
        xityPickCollectionView.showsHorizontalScrollIndicator = false
        xityPickCollectionView.reloadData()
    }
    
    @objc private func lostNetworkConnection() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "NetworkConnectionSegue", sender: self)
        }
    }
    
    
    
    private func setUpNotificationObservers() {
        
        
        //Reload Collection View Data
        notificationCenter.addObserver(self, selector: #selector(reloadData), name: notifications.reloadDashboardCVData.name, object: nil)
        
        //Hide Views
        notificationCenter.addObserver(self, selector: #selector(updateViews), name: notifications.userAuthUpdated.name, object: nil)
        
        //Scroll To Top
        notificationCenter.addObserver(self, selector: #selector(scrollToTop), name: notifications.scrollToTop.name, object: nil)
        
        //Banner SlideShow Start
        notificationCenter.addObserver(self, selector: #selector(startTimer), name: notifications.modalDismissed.name, object: nil)
        
        //Favorites
        notificationCenter.addObserver(self, selector: #selector(reloadData), name: notifications.userFavoritesUpdated.name, object: nil)
        
        //Background
        notificationCenter.addObserver(self, selector: #selector(endTimer), name: UIApplication.willResignActiveNotification, object: nil)
        
        //Network Notifications
        notificationCenter.addObserver(self, selector: #selector(lostNetworkConnection), name: notifications.lostConnection.name, object: nil)
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
        case xityExclusivesCollectionView:
            size = CGSize(width: 155, height: height)
            return size
        case xityPickCollectionView:
            size = CGSize(width: 155, height: height)
            return size
        case venueCollectionView:
            size = CGSize(width: 155, height: height)
            return size
        case favoritesCollectionView:
            size = CGSize(width: 155, height: height)
            return size
        case xityPickCollectionView:
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
            return  100
            
        case todayCollectionView:
            if subscriptionController.seeAllData == false {
                var index = 0
                halfTodayShows = [XityShow]()
                for show in XityShowController.todayShowArray {
                    if index % 2 == 0 {
                        halfTodayShows.append(show)
                    }
                    index += 1
                }
                return halfTodayShows.count
            } else {
                return XityShowController.todayShowResultsArray.count
            }
            
        case xityExclusivesCollectionView:
            return BusinessController.citiesArray.count
            
        case venueCollectionView:
            return BusinessController.businessTypeArray.count
            
        case favoritesCollectionView:
            if subscriptionController.favorites {
                return FavoriteController.favoritesArray.count
            } else {
                if FavoriteController.favoritesArray.count < 1 {
                    return 0
                } else {
                   return 1
                }
            }
            
            
        case xityPickCollectionView:
            if currentUserController.currentUser == nil {
                XityShowController.weeklyPicksArray.shuffle()
                if XityShowController.weeklyPicksArray.count < 1 {
                    return XityShowController.weeklyPicksArray.count
                } else {
                    return 1
                }
            } else {
                XityShowController.weeklyPicksArray.sort(by: {$0.show.date < $1.show.date})
                return XityShowController.weeklyPicksArray.count
            }
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
            bannerAdCell.bannerAd = BusinessBannerAdController.businessAdArray[indexPath.row % BusinessBannerAdController.businessAdArray.count]
            return bannerAdCell
            
        case todayCollectionView:
            venueCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! BandVenueCollectionViewCell
            
            if subscriptionController.seeAllData == false {
                venueCell.venue = halfTodayShows[indexPath.row].business
                return venueCell
            } else {
                venueCell.venue = XityShowController.todayShowResultsArray[indexPath.row].business
                return venueCell
            }
            
        case xityExclusivesCollectionView:
            cityCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as! CitiesCollectionViewCell
            cityCell.city = BusinessController.citiesArray[indexPath.row]
            return cityCell
            
        case venueCollectionView:
            businessTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessTypeCell", for: indexPath) as! CitiesCollectionViewCell
            businessTypeCell.businessType = BusinessController.businessTypeArray[indexPath.row]
            return businessTypeCell
            
        case favoritesCollectionView:
            venueCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! BandVenueCollectionViewCell
            
            for fav in FavoriteController.favoritesArray {
                if fav.bandFavorite != nil {
                    venueCell.band = FavoriteController.favoritesArray[indexPath.row].bandFavorite
                } else {
                    venueCell.venue = FavoriteController.favoritesArray[indexPath.row].venueFavorite
                }
            }
            
            return venueCell
            
            
            
            
        case xityPickCollectionView:
            xityPickCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyCell", for: indexPath) as! BandVenueCollectionViewCell
            xityPickCell.xityPick = XityShowController.weeklyPicksArray[indexPath.row]
            return xityPickCell
        default:
            return cell
        }

        //return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch collectionView {
        case todayCollectionView:
            sharedIndexPath = indexPath
            checkForAdThenSegue(to: todaySegue)
            
        case favoritesCollectionView:
            sharedIndexPath = indexPath
            if FavoriteController.favoritesArray[indexPath.row].venueFavorite != nil {
                checkForAdThenSegue(to: venueFavSegue)
            } else {
                checkForAdThenSegue(to: bandFavSegue)
            }
            
        case xityPickCollectionView:
            sharedIndexPath = indexPath
            checkForAdThenSegue(to: xityPickSegue)
            
        case xityExclusivesCollectionView:
            sharedIndexPath = indexPath
            performSegue(withIdentifier: "DealsComingSoonSegue", sender: self)
        default:
            break
        }
    }
    
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         //Pass the selected object to the new view controller.
        if segue.identifier == todaySegue {
            endTimer()
            guard let businessVC = segue.destination as? VenueDetailViewController else {return}
            var selected = XityShowController.todayShowResultsArray[sharedIndexPath.row]
            if subscriptionController.seeAllData == false {
                selected = halfTodayShows[sharedIndexPath.row]
            }
            
            let business = selected.business
            let xityBusiness = XityBusinessController.businessArray.first(where: {$0.business == business})
            businessVC.currentBusiness = xityBusiness
            businessVC.featuredShow = selected
            
        }
        
        if segue.identifier == venueFavSegue {
            endTimer()
            guard let businessVC = segue.destination as? VenueDetailViewController else {return}
            let business = FavoriteController.favoritesArray[sharedIndexPath.row].venueFavorite
            
            let xityBusiness = XityBusinessController.businessArray.first(where: {$0.business == business})
            xityBusiness?.xityShows.removeAll(where: {$0.show.date < timeController.threeHoursAgo})
            
            businessVC.featuredShow = xityBusiness?.xityShows.first
            businessVC.currentBusiness = xityBusiness!
        }
        
        if segue.identifier == bandFavSegue {
            endTimer()
            guard let bandVC = segue.destination as? BandDetailViewController else {return}
            let band = FavoriteController.favoritesArray[sharedIndexPath.row].bandFavorite
            
            let xityBand = XityBandController.bandArray.first(where: {$0.band == band})
            xityBand?.xityShows.removeAll(where: {$0.show.date < timeController.threeHoursAgo})
            
            bandVC.currentBand = xityBand
        }
        
        if segue.identifier == xityPickSegue {
            endTimer()
            guard let businessVC = segue.destination as? VenueDetailViewController else {return}
            let pick = XityShowController.weeklyPicksArray[sharedIndexPath.row]
            let xityBusiness = XityBusinessController.businessArray.first(where: {$0.business == pick.business})
            businessVC.currentBusiness = xityBusiness
            businessVC.featuredShow = pick
            
        }
        
        if segue.identifier == dealsSoonSegue {
            
        }
    }
}

//MARK: Google Ads Protocols/Functions
extension DashboardViewController: GADFullScreenContentDelegate {
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        endTimer()
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        performSegue(withIdentifier: segueToPerform, sender: self)
        createInterstitialAd()
    }
    
    //Functions
    private func createInterstitialAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: userAdController.activePopUpAdUnitID, request: request) { [self] ad, error in
            
            if let error = error {
                NSLog("Error Displaying Ad: \(error.localizedDescription)")
                return
            }
            interstitialAd = ad
            interstitialAd?.fullScreenContentDelegate = self
        }
    }
    
    private func checkForAdThenSegue(to segue: String) {
        segueToPerform = segue
        
        if interstitialAd != nil && subscriptionController.noPopupAds == false {
            if userAdController.shouldShowAd() {
                interstitialAd?.present(fromRootViewController: self)
            } else {
                performSegue(withIdentifier: segue, sender: self)
            }
        } else {
            performSegue(withIdentifier: segue, sender: self)
        }
    }
}

//MARK: Background to Foreground Functions
extension DashboardViewController {
    
    private func addBackGroundNotificationObservers() {
        let dashboardNotificationCenter = NotificationCenter.default
        
        dashboardNotificationCenter.addObserver(self, selector: #selector(reloadData), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        dashboardNotificationCenter.addObserver(self, selector: #selector(launchLoadingScreen), name: UIApplication.significantTimeChangeNotification, object: nil)
        
        dashboardNotificationCenter.addObserver(self, selector: #selector(reloadData), name: notifications.reloadAllData.name, object: nil)
    }
    
    @objc private func launchLoadingScreen() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ReloadDataSegue", sender: self)
        }
    }
}
