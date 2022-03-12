//
//  BandSearchViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/23/21.
//

import UIKit
import GoogleMobileAds

class BandSearchViewController: UIViewController {
    
    //Properties
    var bandResultsArray = [XityBand]()
    //var bandArray = XityBandController.bandArray
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerAdCollectionView: UICollectionView!
    
    //Banner
    var timer = Timer()
    
    //SearchBar
    @IBOutlet weak var searchBar: UISearchBar!
    let searchController = UISearchController()
    
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    //Google Ad Properties
    private var interstitialAd: GADInterstitialAd?
    lazy private var segueToPerform = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightConstraint.constant = DeviceController.heightConstraint //heightConstraint handles scrolling down to cut off just the banner photo
        
        updateViews()
        createInterstitialAd()
        setUpNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.tintColor = UIColor.yellow
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
    
    
    private func setUpCollectionAndTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        bandResultsArray = XityBandController.bandArray
        arrangeBandResultsArray()
        
        bannerAdCollectionView.dataSource = self
        bannerAdCollectionView.delegate = self
        
        
    }
    
    //MARK: Functions
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

    //MARK: UpdateViews
    @objc private func updateViews() {
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.barTintColor = .clear
        searchBar.searchTextField.textColor = .white
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search Bands By Name"
        
        tableView.contentInset.bottom = 40
        
        setUpCollectionAndTableView()
        hideKeyboardWhenTappedAround()
    }
    
    
    //MARK: Banner Ad
    @objc private func bannerChange() {
        let shownPath = bannerAdCollectionView.indexPathsForVisibleItems
        guard let currentPath = shownPath.first else {return}
    
        var indexPath = IndexPath(row: currentPath.row + 1, section: 0)
        
        //High Count For Infinite Loop: See Banner Ad Collection View
        if currentPath.row < 100 {
            self.bannerAdCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        } else {
            indexPath = IndexPath(row: 0, section: 0)
            self.bannerAdCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
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
    
    // MARK: - Segue

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        endTimer()
        if segue.identifier == "BandSegue" {
            guard let bandDetailVC = segue.destination as? BandDetailViewController else {return}
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let band = bandResultsArray[indexPath.row]
            bandDetailVC.currentBand = band
        }
    }
}


//MARK: TableView
extension BandSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bandResultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
        
        cell.xityBand = bandResultsArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkForAdThenSegue(to: "BandSegue")
    }
    
}


//MARK: CollectionView
extension BandSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        
        size.height = height
        size.width = width
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //bannerAd Config
        return 101
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var bannerAdCell = BannerAdBusinessPicsCollectionViewCell()
        bannerAdCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerAdCell", for: indexPath) as! BannerAdBusinessPicsCollectionViewCell
        //% for indexpath to allow for infinite loop: See Banner Ad Section
        bannerAdCell.bannerAd = BusinessBannerAdController.businessAdArray[indexPath.row % BusinessBannerAdController.businessAdArray.count]
        return bannerAdCell
    }
    
    
}

//MARK: Search Protocols
extension BandSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let subControl = SubscriptionController.self
        subControl.userFeaturesAvailableCheck(feature: subControl.search, viewController: self) {
            startSearch(searchText: searchText)
        }
        
    }
    
    private func startSearch(searchText: String) {
        if searchText == "" {
            bandResultsArray = XityBandController.bandArray
            arrangeBandResultsArray()
        } else {
            bandResultsArray = XityBandController.bandArray.filter({$0.band.name.localizedCaseInsensitiveContains(searchText)})
            arrangeBandResultsArray()
        }
    }
    
    private func arrangeBandResultsArray() {
        bandResultsArray.sort(by: {$0.band.name < $1.band.name})
        bandResultsArray.sort(by: {($0.band.photo != nil) && ($1.band.photo == nil)})
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.text = ""
            searchBar.resignFirstResponder()
        }
        
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.searchTextField.resignFirstResponder()
        return true
    }
}

//MARK: Google Ads Protocols/Functions
extension BandSearchViewController: GADFullScreenContentDelegate {
    
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
        
        if interstitialAd != nil && SubscriptionController.noPopupAds == false {
            
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
