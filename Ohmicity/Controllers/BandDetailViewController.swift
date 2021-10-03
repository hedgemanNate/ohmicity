//
//  BandDetailViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/15/21.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import MaterialComponents.MaterialActivityIndicator
import MaterialComponents.MaterialProgressView
import EventKitUI
import MaterialComponents
import GoogleMobileAds

class BandDetailViewController: UIViewController {
    
    //Properties
    var currentBand: XityBand?
    @IBOutlet weak var bandImage: UIImageView!
    @IBOutlet weak var bandNameLabel: UILabel!
    
    //Buttons
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var listenButton: UIButton!
    
    //Ratings
    @IBOutlet weak var ratingButton: UIButton!
    
    //Segue
    let signInSegue = "ToSignIn"
    let ratingsSegue = "ToRatings"
    
    //Collection View
    @IBOutlet weak var bannerAdCollectionView: UICollectionView!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    //Table View
    @IBOutlet weak var upcomingShowsTableView: UITableView!
    
    //BannerAd
    var timer = Timer()
    @IBOutlet weak var topAdView: UIView!
    
    //Events
    let store = EKEventStore()
    var addressLocation: CLLocation?
    var coordinate: CLLocationCoordinate2D?
    
    //Loader
    @IBOutlet weak var supportView: UIView!
    @IBOutlet weak var supportIndicatorView: UIView!
    @IBOutlet weak var buttonIndicatorView: UIView!
    @IBOutlet weak var xityLogoImageView: UIImageView!
    @IBOutlet weak var supportLabel: UILabel!
    let supportIndicator5 = MDCActivityIndicator()
    let supportIndicator4 = MDCActivityIndicator()
    let supportIndicator3 = MDCActivityIndicator()
    let supportIndicator2 = MDCActivityIndicator()
    let supportIndicator1 = MDCActivityIndicator()
    let supportIndicatorButton = MDCActivityIndicator()
    let hapticGenerator = UIImpactFeedbackGenerator(style: .heavy)
    var shouldShowSupportInfo = false
    let strokeWidth: CGFloat = 9
    
    //MARK: Fan Support Properties
    @IBOutlet weak var separatorView: UIView!
    let separatorProgress = MDCProgressView()
    @IBOutlet weak var weekAdsLabel: UILabel!
    @IBOutlet weak var interviewLabel: UILabel!
    @IBOutlet weak var photoshootLabel: UILabel!
    @IBOutlet weak var studioLabel: UILabel!
    @IBOutlet weak var musicVidLabel: UILabel!
    
    var supportValue: Float = 1300
    @IBOutlet weak var step1Label: UILabel!
    var step1Value: Float = 50
    var step1Percentage: Float = 0 {
        didSet {
            if step1Percentage >= 1 {
                step1Percentage = 1
            }
        }
    }
    @IBOutlet weak var step2Label: UILabel!
    var step2Value: Float = 100
    var step2Percentage: Float = 0 {
        didSet {
            if step2Percentage >= 1 {
                step2Percentage = 1
            }
        }
    }
    @IBOutlet weak var step3Label: UILabel!
    var step3Value: Float = 500
    var step3Percentage: Float = 0 {
        didSet {
            if step3Percentage >= 1 {
                step3Percentage = 1
            }
        }
    }
    @IBOutlet weak var step4Label: UILabel!
    var step4Value: Float = 2000
    var step4Percentage: Float = 0 {
        didSet {
            if step4Percentage >= 1 {
                step4Percentage = 1
            }
        }
    }
    @IBOutlet weak var step5Label: UILabel!
    var step5Value: Float = 5000
    var step5Percentage: Float = 0 {
        didSet {
            if step5Percentage >= 1 {
                step4Percentage = 1
            }
        }
    }
    
    //Google Ad Properties
    private var interstitialAd: GADInterstitialAd?
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        delegateDataSourceSetup()
        setUpNotificationObservers()
        supportLogicCalculator()
        supportIndicatorSetup()
        createInterstitialAd()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startTimer()
        hapticGenerator.prepare()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        endTimer()
        notificationCenter.post(notifications.modalDismissed)
        super.viewDidDisappear(animated)
    }
    
    
    //MARK: Button Actions
    @IBAction func breaker(_ sender: Any) {
        recommendationController.pushRecommendations()
        
    }
    
    @IBAction func listenButtonTapped(_ sender: Any) {
        checkForAdThenRunFunction()
    }
    
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let currentBand = currentBand else {NSLog("No Current Band Found: favoriteButtonTapped: bandDetailViewController"); return }
        let currentUser = currentUserController.currentUser
        
        //MARK: BETA
        if currentUser != nil /*&& (currentUser?.subscription == .BackStagePass || currentUser?.subscription == .FullAccessPass) */{
            if currentUser!.favoriteBands.contains(currentBand.band.bandID) {
                currentUser!.favoriteBands.removeAll(where: {$0 == currentBand.band.bandID})
                NSLog("Business Removed From Favorites")
                currentUser!.lastModified = Timestamp()
                
                do {
                    try ref.userDataPath.document(currentUser!.userID).setData(from: currentUser)
                    notificationCenter.post(notifications.userFavoritesUpdated)
                    DispatchQueue.main.async {
                        self.favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
                    }
                } catch {
                    NSLog("Error Removing favoriteBands from database")
                }
            } else {
                NSLog("\(currentBand.band.bandID) added to Favorites")
                currentUser!.favoriteBands .append(currentBand.band.bandID)
                currentUser!.lastModified = Timestamp()
                
                do {
                    try ref.userDataPath.document(currentUser!.userID).setData(from: currentUser)
                    notificationCenter.post(notifications.userFavoritesUpdated)
                    DispatchQueue.main.async {
                        self.favoriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
                    }
                } catch {
                    NSLog("Error Adding favoriteBusiness to database")
                }
            }
        } else if currentUser == nil {
            self.performSegue(withIdentifier: "ToSignIn", sender: self)
        } else if currentUser?.subscription == .FrontRowPass || currentUser?.subscription == .None {
            performSegue(withIdentifier: "ToPurchaseSegue", sender: self)
        }
        
    }
    
    @IBAction func ratingsButtonTapped(_ sender: Any) {
        if currentUserController.currentUser == nil {
            performSegue(withIdentifier: signInSegue, sender: self)
        } else {
            performSegue(withIdentifier: ratingsSegue, sender: self)
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
    
    //MARK: Update Views
    @objc private func updateViews() {
        //Support UI
        supportLabel.layer.zPosition = 98
        supportButton.layer.zPosition = 100
        xityLogoImageView.layer.zPosition = 97
        xityLogoImageView.alpha = 1
        
        //Progress View UI
        if step1Percentage == 1 {
            weekAdsLabel.isEnabled = true
        }
        if step2Percentage == 1 {
            interviewLabel.isEnabled = true
        }
        if step3Percentage == 1 {
            photoshootLabel.isEnabled = true
        }
        if step4Percentage == 1 {
            studioLabel.isEnabled = true
        }
        if step5Percentage == 1 {
            musicVidLabel.isEnabled = true
        }
        
        //Top Area Under Banner Ads
        guard let currentBand = currentBand else { NSLog("🚨 No current band found"); return}
        
        if currentBand.band.photo == nil {
            self.bandImage.image = UIImage(named: "DefaultBand.png")
        } else {
            let bandImage = UIImage(data: currentBand.band.photo!)
            self.bandImage.image = bandImage
        }
        
        let bandMedia = currentBand.band.mediaLink ?? ""
        
        if bandMedia == "" {
            listenButton.setTitle("No Media To Hear", for: .normal)
            listenButton.isEnabled = false
        } else {
            listenButton.setTitle("Take A Listen", for: .normal)
            listenButton.isEnabled = true
        }
        bandNameLabel.text = currentBand.band.name
        
        if currentUserController.currentUser == nil {
            supportButton.isEnabled = false
            supportLabel.text = "Sign In To Give Your Support"
        } else {
            supportButton.isEnabled = true
            supportLabel.text = "Tap To Show Your Support"
        }
        
        guard let currentUser = currentUserController.currentUser else { NSLog("🚨 No current user for favorites"); return}
        
        if currentUser.favoriteBands.contains(currentBand.band.bandID) {
            favoriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        }
        
        guard let blackoutDate = currentUserController.currentUser?.supportBlackOutDate else { NSLog("🚨 No currentUser.supportBlackOutDate???"); return}
        if blackoutDate > Date() {
            print("\(blackoutDate) should be animated")
            shouldShowSupportInfo = true
            DispatchQueue.main.async {
                self.supportButtonPushedAnimation()
            }
        }
    }
    
    
    //MARK: Functions
    private func delegateDataSourceSetup() {
        bannerAdCollectionView.delegate = self
        bannerAdCollectionView.dataSource = self
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        upcomingShowsTableView.delegate = self
        upcomingShowsTableView.dataSource = self
        upcomingShowsTableView.allowsSelection = true
    }
    
    private func setUpNotificationObservers() {
        
        //Hide Views
        notificationCenter.addObserver(self, selector: #selector(updateViews), name: notifications.userAuthUpdated.name, object: nil)
        
        //Banner SlideShow Start
        notificationCenter.addObserver(self, selector: #selector(startTimer), name: notifications.modalDismissed.name, object: nil)
        
        //Background
        notificationCenter.addObserver(self, selector: #selector(endTimer), name: UIApplication.willResignActiveNotification, object: nil)
        
        //Network Connection
        //notificationCenter.addObserver(self, selector: #selector(lostNetworkConnection), name: notifications.lostConnection.name, object: nil)
    }
    
    private func listenButtonFunction() {
        let bandMedia = currentBand?.band.mediaLink ?? ""
                guard let url = URL(string: bandMedia) else {
                  return //be safe
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    
     // MARK: Segue
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
         if segue.identifier == ratingsSegue {
             guard let destinationVC = segue.destination as? RatingsViewController else {return}
             destinationVC.currentBand = currentBand
             
         }
     // Pass the selected object to the new view controller.
     }
     
    
}


//MARK: Collection View
extension BandDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //guard let currentBand = currentBand else {return 0}
        
        switch collectionView {
        case bannerAdCollectionView:
            return 50
        case genreCollectionView:
            return 200
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        
        switch collectionView {
        case bannerAdCollectionView:
            size = CGSize(width: width, height: height)
            return size
        case genreCollectionView:
            size = CGSize(width: 155, height: height)
            return size
        default:
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let currentBand = currentBand else {return UICollectionViewCell()}
        
        switch collectionView {
        case bannerAdCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerAdCell", for: indexPath) as? BannerAdBusinessPicsCollectionViewCell else {return UICollectionViewCell()}
            
            cell.bannerAd = businessBannerAdController.businessAdArray[indexPath.row % businessBannerAdController.businessAdArray.count]
            return cell
            
        case genreCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCell", for: indexPath) as? CitiesCollectionViewCell else {return UICollectionViewCell()}
            cell.bandGenre = currentBand.band.genre[indexPath.row % currentBand.band.genre.count]
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    
}

//MARK: Table View
extension BandDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentBand = currentBand else {return 0}
        
        switch tableView {
        case upcomingShowsTableView:
            return currentBand.xityShows?.count ?? 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        dateFormatter.dateFormat = timeController.dayMonthDay
        dateFormatter2.dateFormat = timeController.time
        
        switch tableView {
        case upcomingShowsTableView:
            let noShow = tableView.dequeueReusableCell(withIdentifier: "NoShowsCell", for: indexPath)
            noShow.textLabel?.text = "No Shows Found"
            let cell = tableView.dequeueReusableCell(withIdentifier: "NextShowsCell", for: indexPath)
            
            guard let currentBand = currentBand else {return noShow}
            guard let upcomingShow = currentBand.xityShows?[indexPath.row].show else {return noShow}
            
            cell.textLabel?.text = "\(dateFormatter.string(from: upcomingShow.date)): \(upcomingShow.venue) @ \(dateFormatter2.string(from: upcomingShow.date))"
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selected = upcomingShowsTableView.indexPathForSelectedRow else {return}
        guard let show = currentBand?.xityShows?[selected.row].show else {return}
        timeController.dateFormatter.dateFormat = timeController.dayMonthDay
        let date = timeController.dateFormatter.string(from: show.date)
        let alert = UIAlertController(title: "Add Show To Your Calendar?", message: "Band: \(show.band)\n Location: \(show.venue)\n Time: \(date)", preferredStyle: .actionSheet)
        let alertAction2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertAction1 = UIAlertAction(title: "Add Show", style: .default) { _ in
            DispatchQueue.main.async {
                let showEvent = self.createEvent()
                switch EKEventStore.authorizationStatus(for: .event) {
                case .notDetermined:
                    DispatchQueue.main.async {
                        self.store.requestAccess(to: .event) { success, error in
                            if success {
                                let eventVC = EKEventViewController()
                                eventVC.delegate = self
                                eventVC.event = showEvent
                                self.present(eventVC, animated: true)
                            }
                        }
                    }
                case .restricted:
                    DispatchQueue.main.async {
                        self.store.requestAccess(to: .event) { success, error in
                            if success {
                                let eventVC = EKEventViewController()
                                eventVC.delegate = self
                                eventVC.event = showEvent
                                self.present(eventVC, animated: true)
                            }
                        }
                    }
                case .denied:
                    break
                case .authorized:
                    DispatchQueue.main.async {
                        self.store.requestAccess(to: .event) { success, error in
                            if success {
                                DispatchQueue.main.async {
                                    let eventVC = EKEventViewController()
                                    let navVC = UINavigationController(rootViewController: eventVC)
                                    navVC.modalPresentationStyle = .overFullScreen
                                    eventVC.delegate = self
                                    eventVC.event = showEvent
                                    self.present(navVC, animated: true)
                                }
                                
                            }
                        }
                    }
                @unknown default:
                    break
                }
            }
        }
        
        alert.addAction(alertAction1)
        alert.addAction(alertAction2)
        present(alert, animated: true, completion: nil)
        
    }
}

//MARK: Event Creation
extension BandDetailViewController: EKEventViewDelegate {
    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        controller.dismiss(animated: true) {
            guard let selected = self.upcomingShowsTableView.indexPathForSelectedRow else {return}
            self.upcomingShowsTableView.deselectRow(at: selected, animated: true)
        }
    }
    
    private func createEvent() -> EKEvent {
        guard let selected = upcomingShowsTableView.indexPathForSelectedRow else {return EKEvent()}
        guard let show = currentBand?.xityShows?[selected.row].show else {return EKEvent()}
        timeController.dateFormatter.dateFormat = timeController.monthDayYear
        let date = timeController.dateFormatter.string(from: show.date)
        let venue = businessController.businessArray.first(where: {$0.name == show.venue})
        let eventShow = EKEvent(eventStore: store)
        let headsUpAlarm = EKAlarm(absoluteDate: show.date - 10800)
        headsUpAlarm.structuredLocation = mapForEvent(venueName: "You made it!")
        let showStartAlarm = EKAlarm(absoluteDate: show.date)
        eventShow.title = "\(show.band)'s \(date) Show"
        eventShow.startDate = show.date
        eventShow.endDate = show.date + 10800
        eventShow.location = venue?.address
        eventShow.notes = "\(show.band)'s show is EXACTLY what you need to destress and have a good time for a couple hours. And don't forget to check and see if \(show.venue) has any exclusive deals you can use tonight!"
        eventShow.alarms = [headsUpAlarm, showStartAlarm]
        let structLocation = mapForEvent(venueName: show.venue)
        print(structLocation.title)
        eventShow.structuredLocation = structLocation

        return eventShow
    }
    
    private func addEvent(eventShow: EKEvent) {
        if !eventAlreadyExists(event: eventShow) {
            do {
                try store.save(eventShow, span: .thisEvent)
            } catch let err {
                NSLog(err.localizedDescription)
            }
        } else {NSLog("Event already existed"); return}
    }
    
    private func eventAlreadyExists(event eventToAdd: EKEvent) -> Bool {
            let predicate = store.predicateForEvents(withStart: eventToAdd.startDate, end: eventToAdd.endDate, calendars: nil)
            let existingEvents = store.events(matching: predicate)
            
            let eventAlreadyExists = existingEvents.contains { (event) -> Bool in
                return eventToAdd.title! == event.title && event.startDate == eventToAdd.startDate
            }
            return eventAlreadyExists
        }
    
    private func mapForEvent(venueName: String) -> EKStructuredLocation {
        guard let selected = upcomingShowsTableView.indexPathForSelectedRow else {return EKStructuredLocation()}
        guard let venueName = currentBand?.xityShows?[selected.row].show.venue else {return EKStructuredLocation()}
        guard let venue = businessController.businessArray.first(where: {$0.name == venueName}) else {return EKStructuredLocation()}
        let geoCoder = CLGeocoder()
        let structLocation = EKStructuredLocation(title: venueName)
        geoCoder.geocodeAddressString(venue.address) { placemarks, error in
            if let error = error {
                NSLog(error.localizedDescription)
            }
            guard let location = placemarks?.first?.location else {return}
            let coordinate = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            structLocation.geoLocation = coordinate
            //structLocation.radius = 0.5
        }
        return structLocation
    }
    
}


//MARK: Support Indicator Area
extension BandDetailViewController {
    
    @objc private func supportButtonTapped() {
        
        //First Checks
        if currentUserController.currentUser == nil {
         performSegue(withIdentifier: "ToSignIn", sender: self)
         return
         }
        
        if shouldShowSupportInfo == true {
            performSegue(withIdentifier: "SupportInfoSegue", sender: self)
            return
        }
        
        guard let currentUser = currentUserController.currentUser else {return}
        guard let currentBand = currentBand else {return}
        
        //Logic
        guard let blackoutDate = currentUser.supportBlackOutDate else {return NSLog("🚨 No currentUser.supportBlackOutDate???")}
        
        if blackoutDate <= Date() {
            let support = XitySupport(userID: currentUser.userID, bandName: currentBand.band.name)
            currentUser.supportBlackOutDate = timeController.aDayFromNow
            
            //Push Data
            xitySupportController.pushXitySupport(support: support)
            currentUserController.pushCurrentUserData()
            
            shouldShowSupportInfo = true
            
            //Support UI
            hapticGenerator.impactOccurred(intensity: 1)
            supportButtonPushedAnimation()
        }
        
        
    }
    
    private func supportButtonPushedAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.buttonIndicatorView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.buttonIndicatorView.transform = .identity
        }
        supportIndicatorButton.startAnimating()
        supportLabel.text = "Tap To Learn More"
    }
    
    private func supportLogicCalculator() {
        let value = 0
        supportValue = Float(value)
        
        step1Percentage = Float(supportValue / step1Value)
        step2Percentage = Float(supportValue / step2Value)
        step3Percentage = Float(supportValue / step3Value)
        step4Percentage = Float(supportValue / step4Value)
        step5Percentage = Float(supportValue / step5Value)
        
        step1Label.text = "\(Int(step1Percentage*100))%"
        step2Label.text = "\(Int(step2Percentage*100))%"
        step3Label.text = "\(Int(step3Percentage*100))%"
        step4Label.text = "\(Int(step4Percentage*100))%"
        step5Label.text = "\(Int(step5Percentage*100))%"
    }
    
    private func supportIndicatorSetup() {
        //Separator
        separatorView.addSubview(separatorProgress)
        separatorProgress.startAnimating()
        
        //Button
        buttonIndicatorView.addSubview(supportIndicatorButton)
        
        //Progress
        supportIndicator5.setProgress(step5Percentage, animated: true)
        supportIndicatorView.addSubview(supportIndicator5)
        supportIndicator5.startAnimating()
        
        supportIndicator4.setProgress(step4Percentage, animated: true)
        supportIndicatorView.addSubview(supportIndicator4)
        buttonIndicatorView.addSubview(supportIndicator4)
        supportIndicator4.startAnimating()
        
        supportIndicator3.setProgress(step3Percentage, animated: true)
        supportIndicatorView.addSubview(supportIndicator3)
        supportIndicator3.startAnimating()
        
        supportIndicator2.setProgress(step2Percentage, animated: true)
        supportIndicatorView.addSubview(supportIndicator2)
        supportIndicator2.startAnimating()
        
        supportIndicator1.setProgress(step1Percentage, animated: true)
        supportIndicatorView.addSubview(supportIndicator1)
        supportIndicator1.startAnimating()
        
        supportIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        //separatorIndicator UI
        separatorProgress.mode = .indeterminate
        separatorProgress.progressTintColors = [UIColor.systemTeal, UIColor.systemOrange, UIColor.systemBlue, UIColor.systemPink, UIColor.systemPurple]
        separatorProgress.trackTintColor = cc.transBlack
        
        separatorProgress.translatesAutoresizingMaskIntoConstraints = false
        separatorProgress.centerXAnchor.constraint(equalTo: separatorView.centerXAnchor).isActive = true
        separatorProgress.centerYAnchor.constraint(equalTo: separatorView.centerYAnchor).isActive = true
        separatorProgress.widthAnchor.constraint(equalTo: separatorView.widthAnchor).isActive = true
        separatorProgress.heightAnchor.constraint(equalTo: separatorView.heightAnchor).isActive = true
        
        
        //supportIndicatorButtonUI
        supportIndicatorButton.indicatorMode = .indeterminate
        supportIndicatorButton.radius = buttonIndicatorView.frame.height / 2.5 - 1
        supportIndicatorButton.cycleColors = [.systemPurple, .systemOrange, .systemGreen, .systemTeal, .systemYellow]
        supportIndicatorButton.strokeWidth = 3
        supportIndicatorButton.trackEnabled = false
        
        
        supportIndicatorButton.translatesAutoresizingMaskIntoConstraints = false
        supportIndicatorButton.centerXAnchor.constraint(equalTo: buttonIndicatorView.centerXAnchor).isActive = true
        supportIndicatorButton.centerYAnchor.constraint(equalTo: buttonIndicatorView.centerYAnchor).isActive = true
        
        //supportIndicator 5 UI
        supportIndicator5.indicatorMode = .determinate
        supportIndicator5.radius = supportIndicatorView.frame.height / 2
        supportIndicator5.cycleColors = [UIColor.systemPurple]
        supportIndicator5.strokeWidth = strokeWidth
        supportIndicator5.trackEnabled = true
        
        
        supportIndicator5.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator5.centerXAnchor.constraint(equalTo: supportIndicatorView.centerXAnchor).isActive = true
        supportIndicator5.centerYAnchor.constraint(equalTo: supportIndicatorView.centerYAnchor).isActive = true
        
        
        //SupportIndicator 4 UI
        supportIndicator4.indicatorMode = .determinate
        supportIndicator4.radius = supportIndicatorView.frame.height / 2.5
        supportIndicator4.cycleColors = [UIColor.systemPink]
        supportIndicator4.strokeWidth = strokeWidth
        supportIndicator4.trackEnabled = true
        
        
        supportIndicator4.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator4.centerXAnchor.constraint(equalTo: supportIndicatorView.centerXAnchor).isActive = true
        supportIndicator4.centerYAnchor.constraint(equalTo: supportIndicatorView.centerYAnchor).isActive = true
        
        //SupportIndicator 3 UI
        supportIndicator3.indicatorMode = .determinate
        supportIndicator3.radius = supportIndicatorView.frame.height / 3.3
        supportIndicator3.cycleColors = [UIColor.systemBlue]
        supportIndicator3.strokeWidth = strokeWidth
        supportIndicator3.trackEnabled = true
        
        
        
        supportIndicator3.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator3.centerXAnchor.constraint(equalTo: supportIndicatorView.centerXAnchor).isActive = true
        supportIndicator3.centerYAnchor.constraint(equalTo: supportIndicatorView.centerYAnchor).isActive = true
        
        //SupportIndicator 2 UI
        supportIndicator2.indicatorMode = .determinate
        supportIndicator2.radius = supportIndicatorView.frame.height / 5
        supportIndicator2.cycleColors = [UIColor.systemOrange]
        supportIndicator2.strokeWidth = strokeWidth
        supportIndicator2.trackEnabled = true
        
        
        supportIndicator2.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator2.centerXAnchor.constraint(equalTo: supportIndicatorView.centerXAnchor).isActive = true
        supportIndicator2.centerYAnchor.constraint(equalTo: supportIndicatorView.centerYAnchor).isActive = true
        
        //SupportIndicator 1 UI
        supportIndicator1.indicatorMode = .determinate
        supportIndicator1.radius = supportIndicatorView.frame.height / 10
        supportIndicator1.cycleColors = [UIColor.systemTeal]
        supportIndicator1.strokeWidth = strokeWidth
        supportIndicator1.trackEnabled = true
        
        
        supportIndicator1.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator1.centerXAnchor.constraint(equalTo: supportIndicatorView.centerXAnchor).isActive = true
        supportIndicator1.centerYAnchor.constraint(equalTo: supportIndicatorView.centerYAnchor).isActive = true
        
        self.supportIndicator1.alpha = 1
        self.supportIndicator2.alpha = 1
        self.supportIndicator3.alpha = 1
        self.supportIndicator5.alpha = 1
        self.supportIndicator1.strokeWidth = strokeWidth
        self.supportIndicator2.strokeWidth = strokeWidth
        self.supportIndicator3.strokeWidth = strokeWidth
        self.supportIndicator5.strokeWidth = strokeWidth
        supportLabel.alpha = 1
        
        self.supportButton.addTarget(self, action: #selector(supportButtonTapped), for: .touchDown)
    }
    
}

//MARK: Google Ads Protocols/Functions
extension BandDetailViewController: GADFullScreenContentDelegate {
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        endTimer()
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        createInterstitialAd()
        listenButtonFunction()
        
    }
    
    //Functions
    private func createInterstitialAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: userAdController.interstitialTestAdID, request: request) { [self] ad, error in
            
            if let error = error {
                NSLog("Error Displaying Ad: \(error.localizedDescription)")
                return
            }
            interstitialAd = ad
            interstitialAd?.fullScreenContentDelegate = self
        }
    }
    
    private func checkForAdThenSegue(to segue: String) {
        
        if interstitialAd != nil && userAdController.showAds == true {
            if userAdController.shouldShowAd() {
                interstitialAd?.present(fromRootViewController: self)
            } else {
                performSegue(withIdentifier: segue, sender: self)
            }
        } else {
            performSegue(withIdentifier: segue, sender: self)
        }
    }
    
    private func checkForAdThenRunFunction() {
        if interstitialAd != nil && userAdController.showAds == true {
            interstitialAd?.present(fromRootViewController: self)
        } else {
            listenButtonFunction()
        }
    }
}
