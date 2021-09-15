//
//  BandDetailViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/15/21.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        delegateDataSourceSetup()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Button Actions
    @IBAction func breaker(_ sender: Any) {
        
    }
    
    @IBAction func rateButtonTapped(_ sender: Any) {
    }
    
    @IBAction func bandNotificationsButtonTapped(_ sender: Any) {
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
    }
    
    @IBAction func supportButtonTapped(_ sender: Any) {
    }
    
    
    //MARK: Functions
    private func updateViews() {
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
