//
//  VenueDetailViewController.swift
//  Ohmicity
//
//  Created by Nate Hedgeman on 5/6/21.
//

import UIKit

class VenueDetailViewController: UIViewController {
    
    //Properties
    weak var currentBusiness: BusinessFullData?
    var nextShowsArray = [Show]()
    var nextShow: Show?
    var todayDate = ""

    @IBOutlet weak var hoursButton: UIButton!
    @IBOutlet weak var listenButton: UIButton!
    
    @IBOutlet weak var businessLogoImageView: UIImageView!
    @IBOutlet weak var bandPhotoImageView: UIImageView!
    
    @IBOutlet weak var tonightsEntLabel: UILabel!
    @IBOutlet weak var bandNameLabel: UILabel!
    @IBOutlet weak var showTimeLabel: UILabel!
    @IBOutlet weak var bandGenreLabel: UILabel!
    @IBOutlet weak var businessRatingLabel: UILabel!
    
    @IBOutlet weak var businessPicsCollectionView: UICollectionView!
    @IBOutlet weak var nextShowsTableView: UITableView!
    
    private var timer = Timer()
    private var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    

    
    @IBAction func callBusinessButtonTapped(_ sender: Any) {
        
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
    
    
    //MARK: - UpdateViews
    
    private func updateViews() {
        //SetTime
        timeController.dateFormatter.dateFormat = timeController.monthDayYear
        todayDate = dateFormatter.string(from: timeController.now)
        
        //Data Source An Delegate Setup
        nextShowsTableView.dataSource = self
        nextShowsTableView.delegate = self
        businessPicsCollectionView.delegate = self
        businessPicsCollectionView.dataSource = self
        
        //Business Logo Setup
        guard let currentBusiness = currentBusiness else { return NSLog("No Current Business Found: updateViews: venueDetailViewController")}
        guard let businessLogoData = currentBusiness.logo else {return NSLog("No Business logo found: updateViews: venueDetailViewController")}
        let businessLogo = UIImage(data: businessLogoData)
        businessLogoImageView.image = businessLogo
        
        //Collection View Timer
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.pictureChange), userInfo: nil, repeats: true)
        }
        timer.fire()
        
        //MARK: - Table Logic
        //Table View data source
        var businessShows = showController.showArray.filter({$0.venue == currentBusiness.name})
        let fourHourBufferTime = todaysDate.addingTimeInterval(-14400)
        businessShows.removeAll(where: {$0.date < fourHourBufferTime})
        var orderedShows = businessShows.sorted(by: {$0.date.compare($1.date) == .orderedAscending})
        //Grabs next Show for displaying
        let nextShow = orderedShows.first
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
            businessRatingLabel.text = "Rate Music Here"
        } else {
            businessRatingLabel.text = "\(currentBusiness.stars)"
        }
        
        
    }
    
    @objc func pictureChange() {
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
        return nextShowsArray.count
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
extension VenueDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let currentBusiness = currentBusiness else { NSLog("No Current Business Found: updateViews: venueDetailViewController"); return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessPicsCell", for: indexPath) as? BannerAdBusinessPicsCollectionViewCell else {return UICollectionViewCell()}
        
        //% in indexPath for infinite scrolling
        cell.businessPic = currentBusiness.pics[indexPath.row % currentBusiness.pics.count]
        return cell
    }
    
    
}
