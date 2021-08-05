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

class VenueDetailViewController: UIViewController {
    
    //MARK: Properties
    var currentUser = currentUserController.currentUser
    var currentBusiness: BusinessFullData?
    var nextShowsArray = [Show]()
    var nextShow: Show?
    var band: Band?
    
    //Slideshow properties
    private var timer = timeController.timer
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
    
    @IBOutlet weak var businessLogoImageView: UIImageView!
    @IBOutlet weak var bandPhotoImageView: UIImageView!
    
    @IBOutlet weak var tonightsEntLabel: UILabel!
    @IBOutlet weak var bandNameLabel: UILabel!
    @IBOutlet weak var showTimeLabel: UILabel!
    @IBOutlet weak var bandGenreLabel: UILabel!
    @IBOutlet weak var businessRatingLabel: UILabel!
    
    @IBOutlet weak var mapNameLabel: UILabel!
    @IBOutlet weak var mapAddressLabel: UILabel!
    
    @IBOutlet weak var businessPicsCollectionView: UICollectionView!
    @IBOutlet weak var nextShowsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        notificationCenter.addObserver(self, selector: #selector(dismissAlert), name: notifications.dismiss.name, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
        //To inform Dashboard to resume its banner ad timer
        notificationCenter.post(notifications.modalDismissed)
    }
    

    //MARK: Buttons Tapped
    
    @IBAction func breaker(_ sender: Any) {
        
    }
    
    @IBAction func callBusinessButtonTapped(_ sender: Any) {
        guard let currentBusiness = currentBusiness else {return NSLog("No Current Business Found: updateViews: venueDetailViewController")}
        let num = String(currentBusiness.phoneNumber)
        
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
        guard let currentBusiness = currentBusiness else {return NSLog("No Current Business Found: favoriteButtonTapped: venueDetailViewController")}
        
        if currentUser != nil {
            if currentUser!.favoriteBusinesses.contains(currentBusiness.venueID!) {
                currentUser!.favoriteBusinesses.removeAll(where: {$0 == currentBusiness.venueID})
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
                currentUser!.favoriteBusinesses.append(currentBusiness.venueID!)
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
        } else {
            return
            //Present Alert View To Tell User To Sign iIn
        }
        
        print(currentUser!.favoriteBusinesses)
    }
    
    @IBAction func listenButtonTapped(_ sender: Any) {
        guard let bandMedia = band?.mediaLink else {return}
        guard let url = URL(string: "\(bandMedia)") else {
          return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    @IBAction func directionsButtonTapped(_ sender: Any) {
        let placemark = MKPlacemark(coordinate: coordinate!, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = currentBusiness?.name

        let regionSpan = MKCoordinateRegion(center: coordinate!, latitudinalMeters: 1000, longitudinalMeters: 1000)
        let launchOptions = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]

        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Functions
extension VenueDetailViewController {
    
    //Dismissed the Operation Hours Alert View
    @objc private func dismissAlert() {
        self.hoursView.removeFromSuperview()
        self.backgroundView.removeFromSuperview()
    }
}


//MARK: - ------UpdateViews--------
extension VenueDetailViewController {
    
    private func updateViews() {
        guard let currentBusiness = currentBusiness else { return NSLog("No Current Business Found: updateViews: venueDetailViewController")}
        guard let businessLogoData = currentBusiness.logo else {return NSLog("No Business logo found: updateViews: venueDetailViewController")}
        
        //SetTime
        timeController.dateFormatter.dateFormat = timeController.monthDayYear
        
        //Banner Photo Adjustments
        businessLogoImageView.layer.cornerRadius = businessLogoImageView.frame.height / 2
        
        //Top Buttons UI -
                //This sets the hearts sizes programmatically
        let fullHeart = UIImage(systemName: "suit.heart.fill")
        let emptyHeart = UIImage(systemName: "suit.heart")
        let large: UIImage.SymbolConfiguration = .init(scale: .large)
        fullHeart?.applyingSymbolConfiguration(large)
        emptyHeart?.applyingSymbolConfiguration(large)
        
        if currentUserController.currentUser != nil {
            if currentUserController.currentUser!.favoriteBusinesses.contains(currentBusiness.venueID!) {
                self.favoriteButton.setImage(fullHeart, for: .normal)
            } else {
                self.favoriteButton.setImage(emptyHeart, for: .normal)
            }
        } else {
            //MARK: FavoriteButton Not Finished
            //Create an alert to let them login if they try to favorite
            self.favoriteButton.isEnabled = false
        }
        
        
        //Map
        mapSetup()
        directionsButton.layer.cornerRadius = directionsButton.frame.height / 2
        mapBackgroundView.alpha = 0.6
        mapBackgroundView.backgroundColor = cc.white
        
        //Data Source An Delegate Setup
        nextShowsTableView.dataSource = self
        nextShowsTableView.delegate = self
        businessPicsCollectionView.delegate = self
        businessPicsCollectionView.dataSource = self
        
        //Business Logo Setup
        let businessLogo = UIImage(data: businessLogoData)
        businessLogoImageView.image = businessLogo
        
        mapNameLabel.text = currentBusiness.name
        mapAddressLabel.text = currentBusiness.address
        
        //Collection View Timer
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.startSlideShow), userInfo: nil, repeats: true)
        }
        timer.fire()
        
        //Stop Dashboard SlideShow
        
        
        //MARK: - Table Logic And Tonights Show Logic
        //Table View data source
        var businessShows = showController.showArray.filter({$0.venue == currentBusiness.name})
        businessShows.removeAll(where: {$0.date < timeController.twoHoursAgo})
        var orderedShows = businessShows.sorted(by: {$0.date.compare($1.date) == .orderedAscending})
        //Grabs next Show for displaying
        let nextShow = orderedShows.first
        self.nextShow = nextShow
        //Removes nextShow from array so its not shown twice
        orderedShows.removeFirst()
        nextShowsArray = orderedShows
        
        //Find Band for Tonights Entertainment and fill out info
        timeController.dateFormatter.dateFormat = timeController.monthDayYear
        var showTimeString = timeController.dateFormatter.string(from: nextShow!.date)
        if showTimeString == timeController.todayString {
            tonightsEntLabel.text = "Tonights Entertainment"
        } else {
            timeController.dateFormatter.dateFormat = timeController.dayMonthDay
            showTimeString = timeController.dateFormatter.string(from: nextShow!.date)
            tonightsEntLabel.text = "The Next Show: \(showTimeString)"
        }
        
        guard let featuredBand = bandController.bandArray.first(where: {$0.name == nextShow?.band}) else {return}
        if let bandImageData = featuredBand.photo {
            let bandImage = UIImage(data: bandImageData)
            bandPhotoImageView.image = bandImage
        }
        bandNameLabel.text = featuredBand.name
        showTimeLabel.text = nextShow?.time
        
        bandGenreLabel.text = ""
        if featuredBand.genre.count >= 1 {
            for genre in featuredBand.genre {
                let genre = genre.rawValue
                bandGenreLabel.text! += "\(genre), "
            }
        }
        
        if currentBusiness.stars == 0 {
            businessRatingLabel.text = "No Rating Yet"
        } else {
            businessRatingLabel.text = "\(currentBusiness.stars)"
        }
        
        //MARK: - Hours of Operations View Initiation
        //The alert itself
        let alertView: OperationHoursAlert = {
            let view = OperationHoursAlert.instanceFromNib(business: currentBusiness)
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
        band = bandController.bandArray.first(where: {$0.name == nextShow?.band})
        if band?.mediaLink == nil {
            listenButton.isEnabled = false
            listenButton.titleLabel?.text = "Band Has No Media"
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
        guard let currentBusiness = currentBusiness else {return NSLog("No Current Business Found: VenueDetailViewController: mapSetup")}
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(currentBusiness.address) { [self] placemarks, error in
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
            pin.title = currentBusiness.name
            map.addAnnotation(pin)
        }
    }
    
    
    //MARK: Slide Show Functions
    @objc func startSlideShow() {
        var indexPath = IndexPath(row: counter, section: 0)
        
        //High Count For Infinite Loop: See Banner Ad Collection View
        if counter < 50 {
            self.businessPicsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            counter += 1
        } else {
            counter = 0
            indexPath = IndexPath(row: 0, section: 0)
            self.businessPicsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            counter = 1
        }
    }
}

//MARK: - TableView
extension VenueDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NextShowsCell", for: indexPath)
        let date = nextShowsArray[indexPath.row].date
        let show = nextShowsArray[indexPath.row]
        timeController.dateFormatter.dateFormat = timeController.dayMonthDay
        let stringDate = timeController.dateFormatter.string(from: date)
        
        
        cell.textLabel?.text = "\(stringDate): \(show.band) @ \(show.time)"
        return cell
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
        guard let currentBusiness = currentBusiness else { NSLog("No Current Business Found: updateViews: venueDetailViewController"); return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessPicsCell", for: indexPath) as? BannerAdBusinessPicsCollectionViewCell else {return UICollectionViewCell()}
        
        //% in indexPath for infinite scrolling
        cell.businessPic = currentBusiness.pics[indexPath.row % currentBusiness.pics.count]
        return cell
    }
}

