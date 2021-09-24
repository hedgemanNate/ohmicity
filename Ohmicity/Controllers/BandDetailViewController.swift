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
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var ratingsView: UIView!
    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    var largeSymbolScaleConfig = UIImage.SymbolConfiguration(scale: .large)
    var starFilledImage = UIImage()
    var starEmptyImage = UIImage()
    var ratingViewIsShown = false
    var givenRating = 0
    var ratingTimer = Timer()
    
    //Collection View
    @IBOutlet weak var bannerAdCollectionView: UICollectionView!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    //Table View
    @IBOutlet weak var upcomingShowsTableView: UITableView!
    @IBOutlet weak var mediaTableView: UITableView!
    
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
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        supportIndicatorSetup()
        hapticGenerator.prepare()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        supportIndicatorSetup()
    }
    
    
    //MARK: Button Actions
    @IBAction func breaker(_ sender: Any) {
        
    }
    
    @IBAction func rateButtonTapped(_ sender: Any) {
        if ratingViewIsShown {
            ratingTimer.invalidate()
            closeRatingView()
        } else {
            ratingViewIsShown = !ratingViewIsShown
            UIView.animate(withDuration: 0.5, delay: 0, options: []) {
                self.ratingsView.transform = CGAffineTransform(translationX: 0, y: -115)
            } completion: { complete in
                if complete == true {
                    self.startHideRatingsViewTimer()
                }
            }

        }
    }
    
    @IBAction func star1ButtonTapped(_ sender: Any) {
        //UI Changes
        self.star1Button.setImage(starFilledImage, for: .normal)
        self.star2Button.setImage(starEmptyImage, for: .normal)
        self.star3Button.setImage(starEmptyImage, for: .normal)
        self.star4Button.setImage(starEmptyImage, for: .normal)
        self.star5Button.setImage(starEmptyImage, for: .normal)
        givenRating = 1
        ratingsLabel.text = "Rating Received"
        startHideRatingsViewTimer()
    }
    
    @IBAction func star2ButtonTapped(_ sender: Any) {
        self.star1Button.setImage(starFilledImage, for: .normal)
        self.star2Button.setImage(starFilledImage, for: .normal)
        self.star3Button.setImage(starEmptyImage, for: .normal)
        self.star4Button.setImage(starEmptyImage, for: .normal)
        self.star5Button.setImage(starEmptyImage, for: .normal)
        givenRating = 2
        ratingsLabel.text = "Rating Received"
        startHideRatingsViewTimer()
    }
    
    @IBAction func star3ButtonTapped(_ sender: Any) {
        self.star1Button.setImage(starFilledImage, for: .normal)
        self.star2Button.setImage(starFilledImage, for: .normal)
        self.star3Button.setImage(starFilledImage, for: .normal)
        self.star4Button.setImage(starEmptyImage, for: .normal)
        self.star5Button.setImage(starEmptyImage, for: .normal)
        givenRating = 3
        ratingsLabel.text = "Rating Received"
        startHideRatingsViewTimer()
    }
    
    @IBAction func star4ButtonTapped(_ sender: Any) {
        self.star1Button.setImage(starFilledImage, for: .normal)
        self.star2Button.setImage(starFilledImage, for: .normal)
        self.star3Button.setImage(starFilledImage, for: .normal)
        self.star4Button.setImage(starFilledImage, for: .normal)
        self.star5Button.setImage(starEmptyImage, for: .normal)
        givenRating = 4
        ratingsLabel.text = "Rating Received"
        startHideRatingsViewTimer()
    }
    
    @IBAction func star5ButtonTapped(_ sender: Any) {
        self.star1Button.setImage(starFilledImage, for: .normal)
        self.star2Button.setImage(starFilledImage, for: .normal)
        self.star3Button.setImage(starFilledImage, for: .normal)
        self.star4Button.setImage(starFilledImage, for: .normal)
        self.star5Button.setImage(starFilledImage, for: .normal)
        givenRating = 5
        ratingsLabel.text = "Rating Received"
        startHideRatingsViewTimer()
    }
    
    @IBAction func bandNotificationsButtonTapped(_ sender: Any) {
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
    }
    

    
    
    //MARK: Update Views
   @objc private func updateViews() {
    //Support UI
    supportIndicatorSetup()
    supportLabel.layer.zPosition = 98
    supportButton.layer.zPosition = 100
    xityLogoImageView.layer.zPosition = 97
    xityLogoImageView.alpha = 0
    
    //Rating UI
    if currentUserController.currentUser == nil {
        ratingButton.isEnabled = false
    }
    ratingsView.layer.zPosition = -1
    guard let starFilledImage = UIImage(systemName: "star.fill", withConfiguration: largeSymbolScaleConfig) else {return}
    self.starFilledImage = starFilledImage
    guard let starEmptyImage = UIImage(systemName: "star", withConfiguration: largeSymbolScaleConfig) else {return}
    self.starEmptyImage = starEmptyImage
    
    
    guard let currentBand = currentBand else { NSLog("No current band found"); return}
    
    if let bandImage = UIImage(data: currentBand.band.photo!) {
        self.bandImage.image = bandImage
    } else {
        self.bandImage.image = UIImage(named: "DefaultBand.png")
    }
    
    //Top Area Under Banner Ads
    bandNameLabel.text = currentBand.band.name
    if ((currentUserController.currentUser?.favoriteBands.contains(currentBand.band.bandID)) != nil) {
        favoriteButton.imageView?.image = UIImage(systemName: "suit.heart.fill")
    } else {
        favoriteButton.imageView?.image = UIImage(systemName: "suit.heart")
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
    
    @objc private func closeRatingView() {
        ratingViewIsShown = !ratingViewIsShown
        UIView.animate(withDuration: 0.5, delay: 0, options: []) { [self] in
            
            self.ratingsView.transform = .identity
            
        } completion: { [self] complete in
            if complete == true && givenRating != 0 {
                print("Rating Creating")
                let userRating = UsersRatings(bandName: currentBand?.band.name ?? "testBand", rating: givenRating)
                let bandRating = BandsRatings(bandName: currentBand?.band.name ?? "testBand", userID: currentUserController.currentUser!.userID, stars: givenRating)
                
                if currentUserController.currentUser?.bandRatings == nil {
                    currentUserController.currentUser?.bandRatings = []
                    currentUserController.currentUser?.bandRatings?.append(userRating)
                    do {
                        try ref.bandsRatingsDataPath.document(bandRating.bandsRatingsID).setData(from: bandRating)
                    } catch (let error) {
                        NSLog(error.localizedDescription)
                    }
                } else {
                    currentUserController.currentUser?.bandRatings?.append(userRating)
                    do {
                        try ref.bandsRatingsDataPath.document(bandRating.bandsRatingsID).setData(from: bandRating)
                    } catch (let error) {
                        NSLog(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func startHideRatingsViewTimer() {
        ratingTimer.invalidate()
        ratingTimer = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(closeRatingView), userInfo: nil, repeats: false)
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
            return currentBand.xityShows.count
            
        case mediaTableView:
            return 1
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentBand = currentBand else {return UITableViewCell()}
        let upcomingShow = currentBand.xityShows[indexPath.row].show
        dateFormatter.dateFormat = timeController.dayMonthDay
        dateFormatter2.dateFormat = timeController.time
        
        switch tableView {
        case upcomingShowsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NextShowsCell", for: indexPath)
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
        /*if currentUserController.currentUser == nil {
            performSegue(withIdentifier: "ToSignIn", sender: self)
            return
        }*/
        
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
        xitySupportController.pushXitySupport(xitySupport: support)
        
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
