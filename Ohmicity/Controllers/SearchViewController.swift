//
//  SearchViewController.swift
//  Ohmicity
//
//  Created by Nate Hedgeman on 5/6/21.
//

import UIKit
import Firebase
import GoogleMobileAds

class SearchViewController: UIViewController {
    
    //Properties
    var showResultsArray: [XityShow]? {didSet { print("Show Results Set")}}
    var businessResultsArray: [XityBusiness]? {didSet { print("Business Results Set")}}
    var bandResultsArray: [XityBand]? {didSet { print("Band Results Set")}}
    
    var genre: Genre?
    var city: City?
    var businessType: BusinessType?
    
    var businessSearchCache = ""
    var bandSearchCache = ""
    var selectedIndex: Int?
    
    //Search
    @IBOutlet weak var searchBar: UITextField!
    
    //Google Ad Properties
    private var interstitialAd: GADInterstitialAd?
    lazy private var interstitialAdUnitID = "ca-app-pub-9052204067761521/5346686403"
    lazy private var interstitialTestAdID = "ca-app-pub-3940256099942544/4411468910"
    
    var timer = Timer()
    
    @IBOutlet weak var bannerAdCollectionView: UICollectionView!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionViews()
        createInterstitialAd()
        updateViews()
        
        notificationCenter.addObserver(self, selector: #selector(endTimer), name: UIApplication.willResignActiveNotification, object: nil)
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        endTimer()
    }
    
    
    //MARK: Buttons Tapped
    
    @IBAction func breaker(_ sender: Any) {
        interstitialAd?.present(fromRootViewController: self)
    }
    
    @IBAction func segmentedControllerTapped(_ sender: Any) {
        
        switch segmentedController.selectedSegmentIndex {
        case 0:
            searchBar.text = businessSearchCache
            searchBar.isEnabled = true
            searchBar.placeholder = "Search Business By Name"
            print("Segmented Business")
        case 1:
            searchBar.placeholder = "Select A City Below To Display Businesses"
            print("Segmented Cities")
        case 2:
            searchBar.text = bandSearchCache
            searchBar.isEnabled = true
            searchBar.placeholder = "Search Band By Name And Genre"
            print("Segmented Bands")
        default:
            print("Segmented Nil")
        }
        
        DispatchQueue.main.async { [self] in
            searchCollectionView.reloadData()
            tableView.reloadData()
        }
    }
    
    
    @IBAction func searchBarChanged(_ sender: Any) {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            businessSearchCache = searchBar.text ?? ""
        case 2:
            bandSearchCache = searchBar.text ?? ""
        default:
            break
        }
        startSearch(searchText: searchBar.text!, genre: genre, city: city, business: businessType)
    }
    
    
}




//MARK: Functions
extension SearchViewController {
    
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
            timer.invalidate()
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
    
    //MARK: Search Function
    private func startSearch(searchText: String, genre: Genre? = nil, city: City? = nil, business: BusinessType? = nil) {
        if segmentedController.selectedSegmentIndex == 2 && genre != nil {
            print("ss1")
            if searchText == "" {
              bandResultsArray = xityBandController.bandArray.filter({$0.band.genre.contains(genre!)})
            } else {
                bandResultsArray = xityBandController.bandArray.filter({$0.band.name.localizedCaseInsensitiveContains(searchText)})
            }
            
        } else if segmentedController.selectedSegmentIndex == 1 && city != nil {
            print("ss2")
            if searchText == "" {
                businessResultsArray = xityBusinessController.businessArray.filter({$0.business.city.contains(city!)})
            } else {
                businessResultsArray = xityBusinessController.businessArray.filter({($0.business.name.localizedStandardContains(searchText))})
            }
            
        } else if segmentedController.selectedSegmentIndex == 0 && business != nil {
            print("ss3")
            if searchText == "" {
                businessResultsArray = xityBusinessController.businessArray.filter({$0.business.businessType.contains(business!)})
            } else {
                businessResultsArray = xityBusinessController.businessArray.filter({($0.business.name.localizedStandardContains(searchText))})
            }
            
            
        } else if segmentedController.selectedSegmentIndex == 0 {
            print("ss4")
            businessResultsArray = xityBusinessController.businessArray.filter({$0.business.name.localizedStandardContains(searchText)})
        } else if segmentedController.selectedSegmentIndex == 2 {
            print("ss5")
            bandResultsArray = xityBandController.bandArray.filter({$0.band.name.localizedCaseInsensitiveContains(searchText)})
        }
        tableView.reloadData()
    }
        

    
    //MARK: - UpdateViews
    private func updateViews() {
        self.hideKeyboardWhenTappedAround()
        searchBar.delegate = self
        searchBar.attributedPlaceholder = NSAttributedString(string: "Search Business By Name",                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        segmentedController.selectedSegmentTintColor = cc.highlightBlue
        
        //Collection View UI
        searchCollectionView.allowsSelection = true
        searchCollectionView.allowsMultipleSelection = true
        
        //Add space to bottom of search table view to clear the tab view
        tableView.contentInset.bottom = 40

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
    
    private func setUpSegmentedControl() {
        
    }
}


//MARK: CollectionView Protocols
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
            businessBannerAdController.businessAdArray.shuffle()
            return 50
        case searchCollectionView:
            switch segmentedController.selectedSegmentIndex {
            case 0:
                return businessController.businessTypeArray.count
            case 1:
                return businessController.citiesArray.count
            case 2:
                return bandController.genreTypeArray.count
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
            bannerAdCell.bannerAd = businessBannerAdController.businessAdArray[indexPath.row % businessBannerAdController.businessAdArray.count]
            return bannerAdCell
        
        case searchCollectionView:
            searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! CitiesCollectionViewCell
            switch segmentedController.selectedSegmentIndex {
            case 0:
                searchCell.businessType = businessController.businessTypeArray[indexPath.row]
                return searchCell
            case 1:
                searchCell.city = businessController.citiesArray[indexPath.row]
                return searchCell
            case 2:
                searchCell.bandGenre = bandController.genreTypeArray[indexPath.row]
                return searchCell
            default:
                return searchCell
            }
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.indexPathsForSelectedItems?.forEach { ip in
            collectionView.cellForItem(at: ip)?.layer.borderWidth = 0
        }
        
        if let item = collectionView.cellForItem(at: indexPath) {
            if selectedIndex == indexPath.row {
                selectedIndex = nil
                item.layer.borderWidth = 0
                item.layer.borderColor = cc.highlightBlue.cgColor
            } else {
                item.layer.borderWidth = 2
                item.layer.borderColor = cc.highlightBlue.cgColor
            }
        }
        switch segmentedController.selectedSegmentIndex {
        case 0:
            genre = nil
            city = nil
            businessType = nil
            
            businessType = businessController.businessTypeArray[indexPath.row]
            if let business = businessType {
                print(business.rawValue)
                startSearch(searchText: searchBar.text ?? "", genre: genre, city: city, business: business)
            }
            
        case 1:
            genre = nil
            city = nil
            businessType = nil
            city = businessController.citiesArray[indexPath.row]
            if let city = city {
                print(city.rawValue)
                startSearch(searchText: searchBar.text ?? "", genre: genre, city: city, business: businessType)
            }
            
        case 2:
            genre = nil
            city = nil
            businessType = nil
            genre = bandController.genreTypeArray[indexPath.row]
            if let genre = genre {
                print(genre.rawValue)
                startSearch(searchText: searchBar.text ?? "", genre: genre, city: city, business: businessType)
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
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            return businessResultsArray?.count ?? 0
        case 1:
            return businessResultsArray?.count ?? 0
        case 2:
            return bandResultsArray?.count ?? 0
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
        case 2:
            cell.xityBand = bandResultsArray?[indexPath.row]
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let shouldShowAds = userAdController.shouldShowAds
        if interstitialAd != nil && shouldShowAds == true {
            interstitialAd?.present(fromRootViewController: self)
            endTimer()
        } else {
            performSegue(withIdentifier: "ToVenue", sender: self)
        }
    }
}


//MARK: Search Protocols
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
        let indexPath = searchCollectionView.indexPathsForSelectedItems?.first
        
        switch segmentedController.selectedSegmentIndex {
        case 0:
            if indexPath != nil {
            let type = businessController.businessTypeArray[indexPath!.row]
            startSearch(searchText: searchBar.text!, business: type)
            } else {
                startSearch(searchText: searchBar.text!)
            }
        case 1:
            if indexPath != nil {
            let type = businessController.citiesArray[indexPath!.row]
            startSearch(searchText: searchBar.text!, city: type)
            } else {
                startSearch(searchText: searchBar.text!)
            }
        case 2:
            if indexPath != nil {
                let type = bandController.genreTypeArray[indexPath!.row]
            startSearch(searchText: searchBar.text!, genre: type)
            } else {
                startSearch(searchText: searchBar.text!)
            }
        default:
            break
        }
        
    }
}

//MARK: Segue
extension SearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToVenue" {
            endTimer()
            guard let destinationVC = segue.destination as? VenueDetailViewController else {return}
            let indexPath = tableView.indexPathForSelectedRow
            
            if segmentedController.selectedSegmentIndex == 2 {
                let band = bandResultsArray![indexPath!.row]
                let business = xityBusinessController.businessArray.first(where: {$0.business == band.xityShows.first?.business})
                destinationVC.xityBusiness = business
                destinationVC.featuredShow = band.xityShows.first
            } else {
                let business = businessResultsArray![indexPath!.row]
                destinationVC.xityBusiness = business
            }
        }
    }
}

//MARK: Google Ads Protocols/Functions
extension SearchViewController: GADFullScreenContentDelegate {
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("!!!!!!DASHBOARD MONEY!!!!!")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        endTimer()
        performSegue(withIdentifier: "ToVenue", sender: self)
        createInterstitialAd()
    }
    
    //Functions
    private func createInterstitialAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: interstitialTestAdID, request: request) { [self] ad, error in
            if let error = error {
                //Handle Ad Error
                NSLog("Error Displaying Ad: \(error.localizedDescription)")
                return
            }
            interstitialAd = ad
            interstitialAd?.fullScreenContentDelegate = self
        }
    }
}


