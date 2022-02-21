//
//  ShowsSearchViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/20/22.
//

import UIKit
import GoogleMobileAds

class ShowsSearchViewController: UIViewController {
    
    //MARK: Properties
    var sortedArray = [XityShow]()
    var sections = [GroupedSection<Date, XityShow>]()
    var filteredSections = [GroupedSection<Date, XityShow>]() {didSet{tableView.reloadData()}}
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerAdCollectionView: UICollectionView!
    
    //Banner
    var timer = Timer()
    
    //SearchButton
    @IBOutlet weak var searchByDateButton: UIButton!
    
    //For Table Selections
    var section = 0
    var row = 0
    
    var datePicker: UIDatePicker?
    
    
    @IBOutlet weak var searchByDateTextField: UITextField!
    
    //SegmentedController
    @IBOutlet weak var venueBandSegmentedController: UISegmentedControl!
    var shouldShowBand: Bool = false {didSet {tableView.reloadData()}}
    
    
    //Google Ad Properties
    private var interstitialAd: GADInterstitialAd?
    lazy private var segueToPerform = "" {
        didSet {
            print(segueToPerform)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        createInterstitialAd()
        setUpNotificationObservers()
        
        ShowController.showArray.sort(by: {$0.date < $1.date})
        let lastShow = ShowController.showArray.last
        datePicker = UIDatePicker()
        datePicker!.locale = .current
        datePicker!.preferredDatePickerStyle = .inline
        datePicker!.datePickerMode = .date
        datePicker!.tintColor = cc.white
        datePicker!.minimumDate = timeController.threeHoursAgo
        datePicker!.maximumDate = lastShow?.date
        createDatePicker()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.tintColor = UIColor.green
        filteredSections = sections.filter { section in
            section.showsForDate.contains(where: {$0.show.date > timeController.threeHoursAgo})
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        endTimer()
    }
    
    //MARK: UpdateViews
    @objc private func updateViews() {
        tableView.contentInset.bottom = 50
        venueBandSegmentedController.selectedSegmentTintColor = cc.highlightBlue
        setUpCollectionAndTableView()
        hideKeyboardWhenTappedAround()
        
        searchByDateButton.layer.cornerRadius = 8
        
    }
    
    @IBAction func breaker(_ sender: Any) {
        
    }
    
    
    //MARK: Functions
    private func setUpCollectionAndTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        bannerAdCollectionView.dataSource = self
        bannerAdCollectionView.delegate = self
        
        //Show Data
        sortedArray = XityShowController.showArray.filter({$0.show.date >= timeController.threeHoursAgo})
        sortedArray.sort(by: {$0.show.date < $1.show.date})
        sections = GroupedSection.group(array: sortedArray, by: {theDayOfTheShow(day: $0.show.date)})
        sections.sort { lhs, rhs in lhs.date < rhs.date }
        
        filteredSections = sections
        sortedArray = []
    }
    
    @objc private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.bannerAdCollectionView.reloadData()
        }
        
    }
    
    private func theDayOfTheShow(day: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: day)
        return calendar.date(from: components)!
    }
    
    //MARK: Date Picker:
        //Its working but the datePicker is only returning the current time and not the time that is selected. BUG
    
    private func createDatePicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.tintColor = cc.white
        toolBar.backgroundColor = cc.white

        let doneButton = UIBarButtonItem(title: "Search Selected Date", style: .plain, target: nil, action: #selector(doneButtonTapped))
        doneButton.tintColor = cc.highlightBlue

        let cancelButton = UIBarButtonItem(title: "See All Dates", style: .plain, target: nil, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .white
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolBar.setItems([doneButton, spacer, cancelButton], animated: true)

        searchByDateTextField.inputAccessoryView = toolBar
        searchByDateTextField.inputView = datePicker
        
        datePicker!.addTarget(self, action: #selector(dateSelected), for: .valueChanged)
    }
    
    @objc private func dateSelected() {
        print(datePicker!.date)
    }

    @objc private func doneButtonTapped() {
        let showDateRange = (datePicker!.date - 7200)...(datePicker!.date + 8600)
        //searchByDateTextField.text = "\(datePicker.date)"

        //let temp = sortedArray.filter({showDateRange.contains($0.show.date)})
        filteredSections = sections.filter { section in
            section.showsForDate.contains(where: {showDateRange.contains($0.show.date)})
                }


        searchByDateTextField.resignFirstResponder()
        view.endEditing(true)
    }

    @objc private func cancelButtonTapped() {
        filteredSections = sections
        searchByDateTextField.resignFirstResponder()
        view.endEditing(true)
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
    
    private func sortByGenre() {
        //Old Code for CPR to be repurposed
//        switch sortSC.selectedSegmentIndex {
//        case 0:
//            sections = GroupedSection.group(array: sortedArray, by: {theDayOfTheClass(day: $0.date)})
//            sections.sort { lhs, rhs in lhs.date < rhs.date }
//            reloadTable()
//        case 1:
//            let filter = sortedArray.filter({ $0.certification == CertificationType.bls })
//            sections = GroupedSection.group(array: filter, by: {theDayOfTheClass(day: $0.date)})
//            sections.sort { lhs, rhs in lhs.date < rhs.date }
//            reloadTable()
//        case 2:
//            let filter = sortedArray.filter({ $0.certification == CertificationType.firstAid })
//            sections = GroupedSection.group(array: filter, by: {theDayOfTheClass(day: $0.date)})
//            sections.sort { lhs, rhs in lhs.date < rhs.date }
//            reloadTable()
//        case 3:
//            let filter = sortedArray.filter({ $0.certification == CertificationType.hrc
//            })
//            sections = GroupedSection.group(array: filter, by: {theDayOfTheClass(day: $0.date)})
//            sections.sort { lhs, rhs in lhs.date < rhs.date }
//            reloadTable()
//
//        default:
//            sortedArray = cprClassController.allClasses
//            reloadTable()
//        }
    }

    //MARK: Button Functions
    @IBAction func searchByDateButtonTapped(_ sender: Any) {
        if searchByDateTextField.isFirstResponder == true {
            searchByDateTextField.resignFirstResponder()
            view.endEditing(true)
        } else {
            searchByDateTextField.becomeFirstResponder()
        }
    }
    
    
    @IBAction func segmentedControlSwitched(_ sender: Any) {
        switch venueBandSegmentedController.selectedSegmentIndex {
        case 0:
            shouldShowBand = false
        case 1:
            shouldShowBand = true
        default:
            break
        }
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
        
        //MUST PASS THE FEATURED SHOW AS WELL!! OR THE DETAIL VIEW WILL JUST SHOW THE STANDARD BAND OR VENUE INFO
        if segue.identifier == "BandSegue" {
            guard let bandDetailVC = segue.destination as? BandDetailViewController else {return}
            let bandID = filteredSections[section].showsForDate[row].band.bandID
            let band = XityBandController.bandArray.first(where: {$0.band.bandID == bandID})
            bandDetailVC.currentBand = band
        }
        
        if segue.identifier == "VenueSegue" {
            let venueID = filteredSections[section].showsForDate[row].business.venueID
            let show = filteredSections[section].showsForDate[row]
            
            guard let venueDetailVC = segue.destination as? VenueDetailViewController else {return}
            guard let venue = XityBusinessController.businessArray.first(where: {$0.business.venueID == venueID}) else {return}
            
            venueDetailVC.currentBusiness = venue
            print(venue.business.name)
            venueDetailVC.featuredShow = show
        }
    }
}


//MARK: TableView
extension ShowsSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    //Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSections[section].showsForDate.count
    }
    
    //Headers
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.filteredSections[section]
        let date = section.date
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let shadowOffset = CGSize(width: 0, height: 10)
        
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = cc.tabBarPurple
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = cc.white
        (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = .left
        (view as! UITableViewHeaderFooterView).layer.shadowColor = UIColor.black.cgColor
        (view as! UITableViewHeaderFooterView).layer.shadowOffset = shadowOffset
        
    }
    
    
    //Cell Details
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
        
        if shouldShowBand == false {
            cell.shouldShowBand = false
        } else {
            cell.shouldShowBand = true
        }
        
        cell.xityShow = filteredSections[indexPath.section].showsForDate[indexPath.row]
        
        return cell
    }
    
    //Cell Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        section = indexPath.section
        row = indexPath.row
        if shouldShowBand == true {
            checkForAdThenSegue(to: "BandSegue")
        } else if shouldShowBand == false {
            checkForAdThenSegue(to: "VenueSegue")
        }
    }
}


//MARK: CollectionView
extension ShowsSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var bannerAdCell = BannerAdBusinessPicsCollectionViewCell()
        bannerAdCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerAdCell", for: indexPath) as! BannerAdBusinessPicsCollectionViewCell
        //% for indexpath to allow for infinite loop: See Banner Ad Section
        bannerAdCell.bannerAd = BusinessBannerAdController.businessAdArray[indexPath.row % BusinessBannerAdController.businessAdArray.count]
        return bannerAdCell
    }
    
    
}


//MARK: Google Ads Protocols/Functions
extension ShowsSearchViewController: GADFullScreenContentDelegate {
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        endTimer()
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        performSegue(withIdentifier: segueToPerform , sender: self)
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




