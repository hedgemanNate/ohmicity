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
    
    
    //Collection View
    @IBOutlet weak var bannerAdCollectionView: UICollectionView!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    //Table View
    @IBOutlet weak var upcomingShowsTableView: UITableView!
    @IBOutlet weak var mediaTableView: UITableView!
    
    //Loader
    @IBOutlet weak var supportView: UIView!
    @IBOutlet weak var xityLogoImageView: UIImageView!
    @IBOutlet weak var supportLabel: UILabel!
    let supportIndicator5 = MDCActivityIndicator()
    let supportIndicator4 = MDCActivityIndicator()
    let supportIndicator3 = MDCActivityIndicator()
    let supportIndicator2 = MDCActivityIndicator()
    let supportIndicator1 = MDCActivityIndicator()
    let hapticGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
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
        supportButtonTapped()
    }
    
    @IBAction func rateButtonTapped(_ sender: Any) {
    }
    
    @IBAction func bandNotificationsButtonTapped(_ sender: Any) {
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
    }
    

    
    
    //MARK: Update Views
   @objc private func updateViews() {
        supportIndicatorSetup()
        supportLabel.layer.zPosition = 100
        supportView.layer.zPosition = 98
        xityLogoImageView.layer.zPosition = 97
        xityLogoImageView.alpha = 0
        
        
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
        if currentUserController.currentUser == nil {
            performSegue(withIdentifier: "ToSignIn", sender: self)
            return
        }
        
        guard let currentUser = currentUserController.currentUser else {return}
        guard let currentBand = currentBand else {return}
        
        let support = XitySupport(userID: currentUser.userID, bandName: currentBand.band.name)
        xitySupportController.pushXitySupport(xitySupport: support)
        
        //Support UI
        hapticGenerator.impactOccurred(intensity: 1)
        supportButtonPushedAnimation()
    }
    
    private func supportButtonPushedAnimation() {
        UIView.animate(withDuration: 1) {
            self.xityLogoImageView.alpha = 1
            self.supportIndicator1.alpha = 0
            self.supportIndicator2.alpha = 0
            self.supportIndicator3.alpha = 0
            self.supportIndicator5.alpha = 0
            self.supportLabel.alpha = 0
            
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
    }
    
    private func supportIndicatorSetup() {
        supportIndicator5.setProgress(0.1, animated: true)
        supportView.addSubview(supportIndicator5)
        supportIndicator5.startAnimating()
        
        supportIndicator4.setProgress(0.15, animated: true)
        supportView.addSubview(supportIndicator4)
        supportIndicator4.startAnimating()

        supportIndicator3.setProgress(0.27, animated: true)
        supportView.addSubview(supportIndicator3)
        supportIndicator3.startAnimating()

        supportIndicator2.setProgress(0.45, animated: true)
        supportView.addSubview(supportIndicator2)
        supportIndicator2.startAnimating()

        supportIndicator1.setProgress(0.78, animated: true)
        supportView.addSubview(supportIndicator1)
        supportIndicator1.startAnimating()
        
        //supportIndicator 5 UI
        supportIndicator5.indicatorMode = .determinate
        supportIndicator5.radius = supportView.frame.height / 2
        supportIndicator5.cycleColors = [UIColor.systemPurple]
        supportIndicator5.strokeWidth = strokeWidth
        supportIndicator5.trackEnabled = true
        
        supportView.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator5.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator5.centerXAnchor.constraint(equalTo: supportView.centerXAnchor).isActive = true
        supportIndicator5.centerYAnchor.constraint(equalTo: supportView.centerYAnchor).isActive = true
        
        
        //SupportIndicator 4 UI
        supportIndicator4.indicatorMode = .determinate
        supportIndicator4.radius = supportView.frame.height / 2.5
        supportIndicator4.cycleColors = [UIColor.systemPink]
        supportIndicator4.strokeWidth = strokeWidth
        supportIndicator4.trackEnabled = true

        supportView.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator4.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator4.centerXAnchor.constraint(equalTo: supportView.centerXAnchor).isActive = true
        supportIndicator4.centerYAnchor.constraint(equalTo: supportView.centerYAnchor).isActive = true

        //SupportIndicator 3 UI
        supportIndicator3.indicatorMode = .determinate
        supportIndicator3.radius = supportView.frame.height / 3.3
        supportIndicator3.cycleColors = [UIColor.systemBlue]
        supportIndicator3.strokeWidth = strokeWidth
        supportIndicator3.trackEnabled = true


        supportView.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator3.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator3.centerXAnchor.constraint(equalTo: supportView.centerXAnchor).isActive = true
        supportIndicator3.centerYAnchor.constraint(equalTo: supportView.centerYAnchor).isActive = true

        //SupportIndicator 2 UI
        supportIndicator2.indicatorMode = .determinate
        supportIndicator2.radius = supportView.frame.height / 5
        supportIndicator2.cycleColors = [UIColor.systemOrange]
        supportIndicator2.strokeWidth = strokeWidth
        supportIndicator2.trackEnabled = true

        supportView.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator2.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator2.centerXAnchor.constraint(equalTo: supportView.centerXAnchor).isActive = true
        supportIndicator2.centerYAnchor.constraint(equalTo: supportView.centerYAnchor).isActive = true

        //SupportIndicator 1 UI
        supportIndicator1.indicatorMode = .determinate
        supportIndicator1.radius = supportView.frame.height / 10
        supportIndicator1.cycleColors = [UIColor.systemTeal]
        supportIndicator1.strokeWidth = strokeWidth
        supportIndicator1.trackEnabled = true

        supportView.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator1.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator1.centerXAnchor.constraint(equalTo: supportView.centerXAnchor).isActive = true
        supportIndicator1.centerYAnchor.constraint(equalTo: supportView.centerYAnchor).isActive = true
        
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
