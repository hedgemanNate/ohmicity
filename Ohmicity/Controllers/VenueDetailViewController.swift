//
//  VenueDetailViewController.swift
//  Ohmicity
//
//  Created by Nate Hedgeman on 5/6/21.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import AVKit

class VenueDetailViewController: UIViewController {
    
    //MARK: Properties
    var currentUser = currentUserController.currentUser
    var xityBusiness: XityBusiness?
    var featuredShow: XityShow?
    var bandMedia: String = ""
    var nextShowsArray = [Show]()
    
    //Slideshow properties
    private var timer = Timer()
    private var counter = 0
    
    //Map Properties
    var addressLocation: CLLocation?
    var coordinate: CLLocationCoordinate2D?
    @IBOutlet weak var mapBackgroundView: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var directionsButton: UIButton!
    
    //Top Buttons And Hours
    @IBOutlet weak var favoriteButton: UIButton!
    var hoursView = OperationHoursAlert()
    private var backgroundView: UIView!
    @IBOutlet weak var hoursButton: UIButton!
    @IBOutlet weak var listenButton: UIButton!
    @IBOutlet weak var bandPhotoButton: UIButton!
    
    @IBOutlet weak var businessLogoImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    
    @IBOutlet weak var bandPhotoImageView: UIImageView!
    
    @IBOutlet weak var tonightsEntLabel: UILabel!
    @IBOutlet weak var bandNameLabel: UILabel!
    @IBOutlet weak var showTimeLabel: UILabel!
    @IBOutlet weak var bandGenreLabel: UILabel!
    @IBOutlet weak var businessRatingLabel: UILabel!
    
    //Map
    @IBOutlet weak var mapNameLabel: UILabel!
    @IBOutlet weak var mapAddressLabel: UILabel!
    
    @IBOutlet weak var businessPicsCollectionView: UICollectionView!
    @IBOutlet weak var nextShowsTableView: UITableView!
    
    //Recommendation Elements
    @IBOutlet private weak var recommendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        setUpNotificationObservers()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Collection View Timer
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        notificationCenter.post(notifications.modalDismissed)
        endTimer()
        //To inform Dashboard to resume its banner ad timer
        
    }
    

    //MARK: Buttons Tapped
    
    @IBAction func breaker(_ sender: Any) {
        
    }
    
    @IBAction func callBusinessButtonTapped(_ sender: Any) {
        guard let xityBusiness = xityBusiness else {return NSLog("No Current Business Found: updateViews: venueDetailViewController")}
        let num = String(xityBusiness.business.phoneNumber)
        
        if let url = URL(string: "tel://\(num)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func hoursButtonTapped(_ sender: Any) {
        self.view.addSubview(backgroundView)
        self.view.addSubview(hoursView)
        setupHoursAlertConstraints()
        print(timeController.dayOfWeek)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let xityBusiness = xityBusiness else {return NSLog("No Current Business Found: favoriteButtonTapped: venueDetailViewController")}
        
        //MARK: BETA
        if currentUser != nil /*&& (currentUser?.subscription == .BackStagePass || currentUser?.subscription == .FullAccessPass) */{
            if currentUser!.favoriteBusinesses.contains(xityBusiness.business.venueID) {
                currentUser!.favoriteBusinesses.removeAll(where: {$0 == xityBusiness.business.venueID})
                NSLog("Business Removed From Favorites")
                currentUser?.lastModified = Timestamp()
                
                do {
                    try ref.userDataPath.document(currentUser!.userID).setData(from: currentUser)
                    notificationCenter.post(notifications.userFavoritesUpdated)
                    DispatchQueue.main.async {
                        self.favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
                    }
                } catch {
                    NSLog("Error Pushing favoriteBusiness")
                }
            } else {
                currentUser!.favoriteBusinesses.append(xityBusiness.business.venueID)
                currentUser!.lastModified = Timestamp()
                
                do {
                    try ref.userDataPath.document(currentUser!.userID).setData(from: currentUser)
                    notificationCenter.post(notifications.userFavoritesUpdated)
                    DispatchQueue.main.async {
                        self.favoriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
                    }
                } catch {
                    NSLog("Error Pushing favoriteBusiness")
                }
            }
        } else if currentUser == nil {
            self.performSegue(withIdentifier: "ToSignIn", sender: self)
        } else if currentUser?.subscription == .FrontRowPass || currentUser?.subscription == .None {
            performSegue(withIdentifier: "ToPurchaseSegue", sender: self)
        }
        
    }
    
    @IBAction func bandPhotoTapped(_ sender: Any) {
        performSegue(withIdentifier: "ToBandSegue", sender: self)
    }
    
    
    @IBAction func listenButtonTapped(_ sender: Any) {
        guard let bandMedia = featuredShow?.band.mediaLink else {return NSLog("Error with Featured Show Media Link")}
        guard let url = URL(string: bandMedia) else {
          return //be safe
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        
        //Future in-app video OR audio solution
//        let player = AVPlayer(url: url)
//        let vc = AVPlayerViewController()
//        vc.player = player
//
//        present(vc, animated: true) {
//            vc.player?.play()
//        }
    }
    
    
    @IBAction func directionsButtonTapped(_ sender: Any) {
        let placemark = MKPlacemark(coordinate: coordinate!, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = xityBusiness?.business.name

        let regionSpan = MKCoordinateRegion(center: coordinate!, latitudinalMeters: 1000, longitudinalMeters: 1000)
        let launchOptions = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]

        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    
    

    // MARK: - Segue

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "ToBandSegue" {
            endTimer()
            guard let destinationVC = segue.destination as? BandDetailViewController else {return}
            let band = featuredShow?.band.name
            let currentBand = xityBandController.bandArray.first(where: {$0.band.name == band})
            destinationVC.currentBand = currentBand
        }
        // Pass the selected object to the new view controller.
    }


}

//MARK: - Functions
extension VenueDetailViewController {
    
    //Dismissed the Operation Hours Alert View
    @objc private func dismissAlert() {
        self.hoursView.removeFromSuperview()
        self.backgroundView.removeFromSuperview()
    }
    
    //Timer
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
    
    private func setUpNotificationObservers() {
        
        //Hide Views
        notificationCenter.addObserver(self, selector: #selector(updateViews), name: notifications.userAuthUpdated.name, object: nil)
        
        //Banner SlideShow Start
        notificationCenter.addObserver(self, selector: #selector(startTimer), name: notifications.modalDismissed.name, object: nil)
        
        //Background
        notificationCenter.addObserver(self, selector: #selector(endTimer), name: UIApplication.willResignActiveNotification, object: nil)
        
        //Network Connection
        //notificationCenter.addObserver(self, selector: #selector(lostNetworkConnection), name: notifications.lostConnection.name, object: nil)
        
        //Hours
        notificationCenter.addObserver(self, selector: #selector(dismissAlert), name: notifications.dismiss.name, object: nil)
    }
}


//MARK: - ------UpdateViews--------
extension VenueDetailViewController {
    
    @objc private func updateViews() {
        guard let xityBusiness = xityBusiness else { return NSLog("No Current Business Found: updateViews: venueDetailViewController")}
        
        let businessLogoData = xityBusiness.business.logo
        
        if currentUserController.currentUser == nil {
            recommendButton.isEnabled = false
            recommendButton.setTitle("Sign In To Recommend", for: .disabled)
        } else {
            recommendButton.isEnabled = true
            recommendButton.setTitle("Recommend", for: .normal)
        }
        
        
        //SetTime
        timeController.dateFormatter.dateFormat = timeController.monthDayYear
        
        //Banner Photo/Info Adjustments
        //businessLogoImageView.layer.cornerRadius = businessLogoImageView.frame.height / 2
        businessNameLabel.text = xityBusiness.business.name
        
        //Top Buttons UI -
                //This sets the hearts sizes programmatically
        let fullHeart = UIImage(systemName: "suit.heart.fill")
        let emptyHeart = UIImage(systemName: "suit.heart")
        let large: UIImage.SymbolConfiguration = .init(scale: .large)
        fullHeart?.applyingSymbolConfiguration(large)
        emptyHeart?.applyingSymbolConfiguration(large)
        bandPhotoButton.setTitle("", for: .normal)
        
        if currentUserController.currentUser != nil {
            if currentUserController.currentUser!.favoriteBusinesses.contains(xityBusiness.business.venueID) {
                self.favoriteButton.setImage(fullHeart, for: .normal)
            } else {
                self.favoriteButton.setImage(emptyHeart, for: .normal)
            }
        } else {
            
        }
        
        
        //Map
        mapSetup()
        directionsButton.layer.cornerRadius = directionsButton.frame.height / 2
        mapBackgroundView.alpha = 0.6
        mapBackgroundView.backgroundColor = cc.white
        
        //Data Source An Delegate Setup
        nextShowsTableView.dataSource = self
        nextShowsTableView.delegate = self
        nextShowsTableView.allowsSelection = true
        
        businessPicsCollectionView.delegate = self
        businessPicsCollectionView.dataSource = self
        
        //Business Logo Setup
        let businessLogo = UIImage(data: businessLogoData)
        businessLogoImageView.image = businessLogo
        
        mapNameLabel.text = xityBusiness.business.name
        mapAddressLabel.text = xityBusiness.business.address
        
        
        //MARK: -Tonights Show Logic
        if featuredShow == nil {
            featuredShow = xityBusiness.xityShows.first ?? blankXityShow
        }
        let featuredBand = featuredShow!.band
        
        //Find Band for Tonight's Show and fill out info
        let showTimeString = featuredShow!.show.dateString
        timeController.dateFormatter.dateFormat = timeController.monthDayYear
        let compareDateString = timeController.dateFormatter.string(from: featuredShow!.show.date)
        
        if compareDateString == timeController.todayString {
            tonightsEntLabel.text = "Tonight's Show"
        } else if showTimeString == "No Show Scheduled" {
            tonightsEntLabel.text = showTimeString
        } else {
            timeController.dateFormatter.dateFormat = timeController.dayMonthDay
            let dayOfWeekAndDate = timeController.dateFormatter.string(from: featuredShow!.show.date)
            tonightsEntLabel.text = "The \(dayOfWeekAndDate) Show"
        }
       
        
        if let bandImageData = featuredBand.photo {
            let bandImage = UIImage(data: bandImageData)
            bandPhotoImageView.image = bandImage
        } else {
            let bandImage = UIImage(named: "DefaultBand.png")
            bandPhotoImageView.image = bandImage
        }
        bandNameLabel.text = featuredBand.name
        
        timeController.dateFormatter.dateFormat = timeController.time
        let time = timeController.dateFormatter.string(from: (featuredShow?.show.date)!)
        showTimeLabel.text = time
        
        bandGenreLabel.text = ""
        if featuredBand.genre.count >= 1 {
            for genre in featuredBand.genre {
                let genre = genre.rawValue
                bandGenreLabel.text! += "\(genre), "
            }
        }
        
        if xityBusiness.business.stars == 0 {
            businessRatingLabel.text = "No Rating Yet"
        } else {
            businessRatingLabel.text = "\(xityBusiness.business.stars)"
        }
        
        //MARK: - Hours of Operations View Initiation
        //The alert itself
        let alertView: OperationHoursAlert = {
            let view = OperationHoursAlert.instanceFromNib(business: xityBusiness.business)
            return view
        }()
        hoursView = alertView
        
        //The backgroundView
        let backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            view.alpha = 0.5
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        self.backgroundView = backgroundView
        
        bandMedia = featuredShow?.band.mediaLink ?? ""
        
        if bandMedia == "" {
            listenButton.setTitle("No Media To Hear", for: .normal)
            listenButton.isEnabled = false
        } else {
            listenButton.setTitle("Take A Listen", for: .normal)
            listenButton.isEnabled = true
        }
    }
}
//MARK: -----UpdateViews End-----



//MARK: Functions
extension VenueDetailViewController {
    
    private func setupHoursAlertConstraints() {
        self.hoursView.translatesAutoresizingMaskIntoConstraints = false
        self.hoursView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.hoursView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        self.hoursView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.hoursView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
    }
    
    
    //MARK: Map
    private func mapSetup() {
        guard let xityBusiness = xityBusiness else {return NSLog("No Current Business Found: VenueDetailViewController: mapSetup")}
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(xityBusiness.business.address) { [self] placemarks, error in
            if let error = error {
                NSLog("Error Converting Address: \(error.localizedDescription)")
            }
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location
            else { return NSLog("Error getting placmark: VenueDetailViewController: mapSetup ")}
            
            map.isUserInteractionEnabled = false
            coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let region = MKCoordinateRegion(center: coordinate!, span: span)
            map.setRegion(region, animated: false)

            //Setup Map Pin
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate!
            pin.title = xityBusiness.business.name
            map.addAnnotation(pin)
        }
    }
    
    
    //MARK:Banner Ad
    @objc func bannerChange() {
        let shownPath = businessPicsCollectionView.indexPathsForVisibleItems
        let currentPath = shownPath.first
    
        var indexPath = IndexPath(row: currentPath!.row + 1, section: 0)
        
        //High Count For Infinite Loop: See Banner Ad Collection View
        if currentPath!.row < 50 {
            self.businessPicsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        } else {
            indexPath = IndexPath(row: 0, section: 0)
            self.businessPicsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
}

//MARK: - TableView
extension VenueDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xityBusiness?.xityShows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NextShowsCell", for: indexPath)
        if xityBusiness?.xityShows.count != 0 {
            let date = xityBusiness!.xityShows[indexPath.row].show.date
            let show = xityBusiness!.xityShows[indexPath.row].show
            timeController.dateFormatter.dateFormat = timeController.dayMonthDay
            let stringDate = timeController.dateFormatter.string(from: date)
            timeController.dateFormatter.dateFormat = timeController.time
            let time = timeController.dateFormatter.string(from: date)
            cell.textLabel?.text = "\(stringDate): \(show.band) @ \(time)"
        } else {
            cell.textLabel?.text = "No Show Scheduled"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let show = xityBusiness?.xityShows[indexPath.row]
        featuredShow = show
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
}

//MARK: - CollectionView
extension VenueDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let xityBusiness = xityBusiness else { NSLog("No Current Business Found: updateViews: venueDetailViewController"); return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessPicsCell", for: indexPath) as? BannerAdBusinessPicsCollectionViewCell else {return UICollectionViewCell()}
        
        //% in indexPath for infinite scrolling
        cell.businessPic = xityBusiness.business.pics[indexPath.row % xityBusiness.business.pics.count]
        return cell
    }
}
