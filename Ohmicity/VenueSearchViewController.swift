//
//  SearchViewController.swift
//  Ohmicity
//
//  Created by Nate Hedgeman on 5/6/21.
//

import UIKit
import Firebase
import GoogleMobileAds


class VenueSearchViewController: UIViewController {
    
    //Properties
    var showResultsArray: [XityShow]? {didSet { print("Show Results Set")}}
    var businessResultsArray: [XityBusiness]? {didSet { print("Business Results Set")}}
    //var bandResultsArray: [XityBand]? {didSet { print("Band Results Set")}}
    
    var genre: Genre?
    var city: City?
    var businessType: BusinessType?
    
    var businessSearchCache = ""
    var bandSearchCache = ""
    var selectedIndex: Int?
    
    //Search
    //@IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Google Ad Properties
    private var interstitialAd: GADInterstitialAd?
    lazy private var segueToPerform = ""
    
    var timer = Timer()
    
    @IBOutlet weak var bannerAdCollectionView: UICollectionView!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionViews()
        createInterstitialAd()
        updateViews()
        setUpNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.tintColor = UIColor.red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        endTimer()
        searchBar.text = ""
    }
    
    
    //MARK: Buttons Tapped
    
    @IBAction func breaker(_ sender: Any) {
        
    }
    
    @IBAction func segmentedControllerTapped(_ sender: Any) {
        
        switch segmentedController.selectedSegmentIndex {
        case 0:
            searchBar.text = businessSearchCache
            searchBar.placeholder = "Search Business By Name"
            //print("Segmented Business")
            searchBar.isUserInteractionEnabled = true
        case 1:
            searchBar.placeholder = "Select A City To Filter"
            searchBar.isUserInteractionEnabled = false
            //print("Segmented Cities")
        default:
            break
            //print("Segmented Nil")
        }
        
        DispatchQueue.main.async { [self] in
            searchCollectionView.reloadData()
            tableView.reloadData()
        }
    }
    
    //MARK: UI ACTIONS
    
}




//MARK: Functions
extension VenueSearchViewController {
    
    private func setUpCollectionViews() {
        bannerAdCollectionView.delegate = self
        bannerAdCollectionView.dataSource = self
        bannerAdCollectionView.allowsSelection = false
        
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.allowsMultipleSelection = false
    }
    
    //MARK: Banner Ad
    @objc private func startTimer() {
        DispatchQueue.main.async {
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.bannerChange), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func endTimer() {
        DispatchQueue.main.async {
            self.timer.invalidate()
        }
    }
    
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
    
    private func setUpNotificationObservers() {
        //Hide Views
        NotifyCenter.addObserver(self, selector: #selector(updateViews), name: Notifications.userAuthUpdated.name, object: nil)
        
        //Banner SlideShow Start
        NotifyCenter.addObserver(self, selector: #selector(startTimer), name: Notifications.modalDismissed.name, object: nil)
        
        //Background
        NotifyCenter.addObserver(self, selector: #selector(endTimer), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotifyCenter.addObserver(self, selector: #selector(reloadData), name: Notifications.reloadAllData.name, object: nil)
        
    }
    
    @objc private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.bannerAdCollectionView.reloadData()
        }
        
    }
    
    //MARK: Search Function
    private func startSearch(searchText: String, city: City? = nil, business: BusinessType? = nil) {
        if segmentedController.selectedSegmentIndex == 1 && city != nil {
            if searchText == "" {
                businessResultsArray = XityBusinessController.businessArray.filter({$0.business.city.contains(city!)})
                tableView.reloadData()
            }
            
        } else if segmentedController.selectedSegmentIndex == 0 && business != nil {
            if searchText == "" {
                businessResultsArray = XityBusinessController.businessArray.filter({$0.business.businessType.contains(business!)})
                tableView.reloadData()
            } else {
                businessResultsArray = XityBusinessController.businessArray.filter({($0.business.name.localizedStandardContains(searchText))})
                tableView.reloadData()
            }
            
            
        } else if segmentedController.selectedSegmentIndex == 0 {
            if searchText == "" {
                businessResultsArray = XityBusinessController.businessArray.sorted(by: {$0.business.name < $1.business.name})
            } else {
                businessResultsArray =  XityBusinessController.businessArray.filter({$0.business.name.localizedStandardContains(searchText)})
            }
            tableView.reloadData()
        }
    }
    

    
    //MARK: - UpdateViews
    @objc private func updateViews() {
        self.hideKeyboardWhenTappedAround()
        searchBar.delegate = self
        searchBar.placeholder = "Search Business By Name"
        searchBar.barTintColor = .clear
        searchBar.searchTextField.textColor = .white
        searchBar.tintColor = .systemTeal
        searchBar.searchTextField.delegate = self
        searchBar.showsCancelButton = true
        
        segmentedController.selectedSegmentTintColor = cc.highlightBlue
        
        //Collection View UI
        searchCollectionView.allowsSelection = true
        searchCollectionView.allowsMultipleSelection = false
        
        //Add space to bottom of search table view to clear the tab view
        tableView.contentInset.bottom = 40
        businessResultsArray = XityBusinessController.businessArray.sorted(by: {$0.business.name < $1.business.name})

    }
    
    @objc private func slideChange() {
        let shownPath = bannerAdCollectionView.indexPathsForVisibleItems
        let currentPath = shownPath.first
        
        var indexPath = IndexPath(row: currentPath!.row + 1, section: 0)
        
        //High Count For Infinite Loop: See Banner Ad Collection View
        if currentPath!.row < 50 {
            self.bannerAdCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        } else {
            indexPath = IndexPath(row: 0, section: 0)
            self.bannerAdCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
}


//MARK: CollectionView Protocols
extension VenueSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        
        switch collectionView {
        case bannerAdCollectionView:
            size = CGSize(width: width, height: height)
            return size
        case searchCollectionView:
            size = CGSize(width: 103, height: height)
            return size
        default:
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case bannerAdCollectionView:
            BusinessBannerAdController.businessAdArray.shuffle()
            return 50
        case searchCollectionView:
            switch segmentedController.selectedSegmentIndex {
            case 0:
                return BusinessController.businessTypeArray.count
            case 1:
                return BusinessController.citiesArray.count
            case 2:
                return BandController.genreTypeArray.count
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var bannerAdCell = BannerAdBusinessPicsCollectionViewCell()
        var searchCell = CitiesCollectionViewCell()
        
        switch collectionView {
        case bannerAdCollectionView:
            bannerAdCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerAdCell", for: indexPath) as! BannerAdBusinessPicsCollectionViewCell
            //% for indexpath to allow for infinite loop: See Banner Ad Section
            bannerAdCell.bannerAd = BusinessBannerAdController.businessAdArray[indexPath.row % BusinessBannerAdController.businessAdArray.count]
            return bannerAdCell
        
        case searchCollectionView:
            searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! CitiesCollectionViewCell
            switch segmentedController.selectedSegmentIndex {
            case 0:
                searchCell.businessType = BusinessController.businessTypeArray[indexPath.row]
                return searchCell
            case 1:
                searchCell.city = BusinessController.citiesArray[indexPath.row]
                return searchCell
            case 2:
                searchCell.bandGenre = BandController.genreTypeArray[indexPath.row]
                return searchCell
            default:
                return searchCell
            }
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.indexPathsForSelectedItems?.forEach { indexPath in
            collectionView.cellForItem(at: indexPath)?.layer.borderWidth = 0
        }
        
        if let item = collectionView.cellForItem(at: indexPath) {
                item.layer.borderWidth = 2
                item.layer.borderColor = cc.highlightBlue.cgColor
        }
        
        switch segmentedController.selectedSegmentIndex {
        case 0:
            city = nil
            businessType = nil
            businessType = BusinessController.businessTypeArray[indexPath.row]
            
            if let business = businessType {
                print(business.rawValue)
                startSearch(searchText: "", city: city, business: business)
            }
            
        case 1:
            city = nil
            businessType = nil
            
            city = BusinessController.citiesArray[indexPath.row]
            if let city = city {
                print(city.rawValue)
                startSearch(searchText: "", city: city, business: businessType)
            }
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let item = collectionView.cellForItem(at: indexPath) {
            item.layer.borderWidth = 0
            switch segmentedController.selectedSegmentIndex {
            case 0:
                businessType = nil
                startSearch(searchText: searchBar.text!)
            case 1:
                city = nil
                businessResultsArray = []
            case 2:
                genre = nil
                startSearch(searchText: searchBar.text!)
            default:
                break
            }
        }
    }
}


//MARK: TableView Protocols
extension VenueSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            return businessResultsArray?.count ?? 1000
        case 1:
            return businessResultsArray?.count ?? 1000
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
        
        switch segmentedController.selectedSegmentIndex {
        case 0:
            cell.xityBusiness = businessResultsArray?[indexPath.row]
        case 1:
            cell.xityBusiness = businessResultsArray?[indexPath.row]
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkForAdThenSegue(to: "ToVenue")
    }
}


//MARK: Search Protocols
extension VenueSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCollectionView.allowsSelection = false
        searchCollectionView.allowsSelection = true
        let subControl = subscriptionController
        subControl.userFeaturesAvailableCheck(feature: subControl.search, viewController: self) {
            guard let searchText = searchBar.text else {return}
            searchCollectionView.reloadData()
            startSearch(searchText: searchText)
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.searchTextField.resignFirstResponder()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchCollectionView.allowsSelection = false
        searchCollectionView.allowsSelection = true
        
    }
}

//MARK: Segue
extension VenueSearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToVenue" {
            endTimer()
            guard let destinationVC = segue.destination as? VenueDetailViewController else {return}
            let indexPath = tableView.indexPathForSelectedRow
            
        let business = businessResultsArray![indexPath!.row]
            destinationVC.currentBusiness = business
        }
    }
}


//MARK: Google Ads Protocols/Functions
extension VenueSearchViewController: GADFullScreenContentDelegate {
    
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


