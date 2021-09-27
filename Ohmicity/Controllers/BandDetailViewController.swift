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

class BandDetailViewController: UIViewController {
    
    //Properties
    var currentBand: XityBand?
    @IBOutlet weak var bandImage: UIImageView!
    @IBOutlet weak var bandNameLabel: UILabel!
    
    //Buttons
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
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
    @IBOutlet weak var mediaTableView: UITableView!
    
    //BannerAd
    var timer = Timer()
    @IBOutlet weak var topAdView: UIView!
    
    //Loader
    @IBOutlet weak var supportView: UIView!
    @IBOutlet weak var supportIndicatorView: UIView!
    @IBOutlet weak var xityLogoImageView: UIImageView!
    @IBOutlet weak var supportLabel: UILabel!
    let supportIndicator5 = MDCActivityIndicator()
    let supportIndicator4 = MDCActivityIndicator()
    let supportIndicator3 = MDCActivityIndicator()
    let supportIndicator2 = MDCActivityIndicator()
    let supportIndicator1 = MDCActivityIndicator()
    let hapticGenerator = UIImpactFeedbackGenerator(style: .heavy)
    var shouldShowSupportInfo = false
    let strokeWidth: CGFloat = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        delegateDataSourceSetup()
        notificationObservers()
        supportIndicatorSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startTimer()
        hapticGenerator.prepare()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        endTimer()
        super.viewDidDisappear(animated)
    }
    
    
    //MARK: Button Actions
    @IBAction func breaker(_ sender: Any) {
        recommendationController.pushRecommendations()
        
    }
    
    @IBAction func bandNotificationsButtonTapped(_ sender: Any) {
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
        supportIndicatorSetup()
        supportLabel.layer.zPosition = 98
        supportButton.layer.zPosition = 100
        xityLogoImageView.layer.zPosition = 97
        xityLogoImageView.alpha = 0
        bannerAdCollectionView.sendSubviewToBack(self.view)
       
        
        
        guard let currentBand = currentBand else { NSLog("No current band found"); return}
        
        if currentBand.band.photo == nil {
            self.bandImage.image = UIImage(named: "DefaultBand.png")
        } else {
            let bandImage = UIImage(data: currentBand.band.photo!)
            self.bandImage.image = bandImage
        }
            
        
        
        //Top Area Under Banner Ads
        bandNameLabel.text = currentBand.band.name
        guard let currentUser = currentUserController.currentUser else { NSLog("no current user for favorites"); return}
        
        if currentUser.favoriteBands.contains(currentBand.band.bandID) {
            favoriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
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
        mediaTableView.delegate = self
        mediaTableView.dataSource = self
    }
    
    private func notificationObservers() {
        notificationCenter.addObserver(self, selector: #selector(updateViews), name: notifications.userAuthUpdated.name, object: nil)
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
        guard let currentBand = currentBand else {return 0}
        
        switch collectionView {
        case bannerAdCollectionView:
            return 50
        case genreCollectionView:
            return currentBand.band.genre.count
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
            cell.bandGenre = currentBand.band.genre[indexPath.row]
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
            
        case mediaTableView:
            return 1
            
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
            
        case mediaTableView:
            //Create a custom cell to hold the media
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}


//MARK: Support Indicator Area
extension BandDetailViewController {
    
    @objc private func supportButtonTapped() {
        
        //Logic
        if currentUserController.currentUser == nil {
         performSegue(withIdentifier: "ToSignIn", sender: self)
         return
         }
        
        if shouldShowSupportInfo == true {
            performSegue(withIdentifier: "SupportInfoSegue", sender: self)
            return
        }
        
        if shouldShowSupportInfo == false {
            shouldShowSupportInfo = true
        }
        
        //Support UI
        hapticGenerator.impactOccurred(intensity: 1)
        supportButtonPushedAnimation()
        
        guard let currentUser = currentUserController.currentUser else {return}
        guard let currentBand = currentBand else {return}
        
        let support = XitySupport(userID: currentUser.userID, bandName: currentBand.band.name)
        xitySupportController.supportInstancesArray.append(support)
        
    }
    
    private func supportButtonPushedAnimation() {
        UIView.animate(withDuration: 1) {
            self.xityLogoImageView.alpha = 1
            self.supportIndicator1.alpha = 0
            self.supportIndicator2.alpha = 0
            self.supportIndicator3.alpha = 0
            self.supportIndicator5.alpha = 0
            
            
            self.supportIndicator4.strokeWidth = 3
        }
        
        supportIndicator1.stopAnimating()
        supportIndicator2.stopAnimating()
        supportIndicator3.stopAnimating()
        supportIndicator4.stopAnimating()
        supportIndicator5.stopAnimating()
        
        supportIndicator4.cycleColors = [.systemPurple, .systemOrange, .systemGreen, .systemTeal, .systemYellow]
        supportIndicator4.indicatorMode = .indeterminate
        supportIndicator4.trackEnabled = false
        supportIndicator4.startAnimating()
        
        supportLabel.text = "Tap Again To Learn More"
    }
    
    private func supportIndicatorSetup() {
        supportIndicator5.setProgress(0.1, animated: true)
        supportIndicatorView.addSubview(supportIndicator5)
        supportIndicator5.startAnimating()
        
        supportIndicator4.setProgress(0.15, animated: true)
        supportIndicatorView.addSubview(supportIndicator4)
        supportIndicator4.startAnimating()
        
        supportIndicator3.setProgress(0.27, animated: true)
        supportIndicatorView.addSubview(supportIndicator3)
        supportIndicator3.startAnimating()
        
        supportIndicator2.setProgress(0.45, animated: true)
        supportIndicatorView.addSubview(supportIndicator2)
        supportIndicator2.startAnimating()
        
        supportIndicator1.setProgress(0.78, animated: true)
        supportIndicatorView.addSubview(supportIndicator1)
        supportIndicator1.startAnimating()
        
        supportIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
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
        xityLogoImageView.alpha = 0
        supportLabel.alpha = 1
        
        self.supportButton.addTarget(self, action: #selector(supportButtonTapped), for: .touchDown)
    }
    
}
