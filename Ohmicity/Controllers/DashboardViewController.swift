//
//  DashboardViewController.swift
//  Ohmicity
//
//  Created by Nate Hedgeman on 5/6/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DashboardViewController: UIViewController {
    
    
    //Properties
    var todayVenueArray: [BusinessFullData] = []
    var todayBandArray: [Band] = []
    var todayShowArray: [Show] = []
    var weeklyVenueArray: [BusinessFullData] = []
    var weeklyShowArray: [Show] = []
    var favBandsArray: [Band] = []
    
    var todayDate: String = "July 14, 2021"
    let bandVenueCellid = "MainCell"
    
    @IBOutlet weak var getPerksButton: UIButton!
    @IBOutlet weak var alreadyAccountButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topAdView: UIView!
    
    
    //Hidden Elements
    var showsToday: Bool = true
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    @IBOutlet weak var hiddenSignUpView: UIView!
    @IBOutlet weak var noShowsView: UIView!
    
    //Collections Views
    @IBOutlet weak var plainCollectionView: UICollectionView!
    @IBOutlet weak var todayCollectionView: UICollectionView!
    @IBOutlet weak var citiesCollectionView: UICollectionView!
    @IBOutlet weak var weeklyCollectionView: UICollectionView!
    @IBOutlet weak var venueCollectionView: UICollectionView!
    
    //Buttons
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var citiesButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var venueButton: UIButton!
    
    //View Backgrounds
    @IBOutlet weak var recommendView: UIView!
    
    //MARK: OPERATIONS
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationObservers()
        updateViews()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func breaker(_ sender: Any) {
        
        ref.businessFullDataPath.whereField("name", isEqualTo: "Banana Factory").getDocuments(source: .cache) { querySnapshot, err in
            if let err = err {
                print(err)
            } else {
                for venue in querySnapshot!.documents {
                    print(venue)
                }
            }
        }
    }
}


//MARK: Functions
extension DashboardViewController {
    //UI Functions
    @objc private func handleHidden() {
        if Auth.auth().currentUser == nil {
            favoritesButton.isHidden = true
            favoritesCollectionView.isHidden = true
            hiddenSignUpView.isHidden = false
        } else {
            favoritesButton.isHidden = false
            favoritesCollectionView.isHidden = false
            hiddenSignUpView.isHidden = true
        }
        
    }
    
    @objc private func scrollToTop() {
        scrollView.scrollToTop(animated: true)
    }
    
    
    //MARK: UPDATEVIEWS
    private func updateViews() {
        //self.getTodaysDate()
        self.getCollectionData()
        setupUpCollectionViews()
//        if todayShowArray != [] {
//            noShowsView.isHidden = true
//        } else {
//            noShowsView.isHidden = false
//        }
    }
    
    //MARK: Logic Functions
    private func getTodaysDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        todayDate = dateFormatter.string(from: Date())
    }
    
    private func getCollectionData() {
        //MARK: Today Data
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        let op1 = BlockOperation {
            self.todayShowArray = showController.showArray.filter({$0.dateString == self.todayDate})
        }
        
        let op2 = BlockOperation {
            for show in self.todayShowArray {
                for venue in businessController.businessArray {
                    if show.venue == venue.name {
                        self.todayVenueArray.append(venue)
                    }
                }
            }
            
            for show in self.todayShowArray {
                for band in bandController.bandArray {
                    if show.band == band.name {
                        self.todayBandArray.append(band)
                    }
                }
            }
        }
        
        op2.addDependency(op1)
        opQueue.addOperations([op1, op2], waitUntilFinished: false)
        
        //End Today Data
    }
    
    
    //MARK: Setup CollectionViews
    private func setupUpCollectionViews() {
        //plainCollectionView.delegate = self
        //plainCollectionView.dataSource = self
        
        todayCollectionView.delegate = self
        todayCollectionView.dataSource = self
    }
    
    
    private func notificationObservers() {
        //Hide Views
        notificationCenter.addObserver(self, selector: #selector(handleHidden), name: notifications.userAuthUpdated.name, object: nil)
        
        //Scroll To Top
        notificationCenter.addObserver(self, selector: #selector(scrollToTop), name: notifications.scrollToTop.name, object: nil)
    }
}


//MARK: Collection View Protocols
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var num: Int?
        
        if collectionView == todayCollectionView {
            num = todayVenueArray.count
        }
        
        return num ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var bandCell = BandVenueCollectionViewCell()
        var cell = UICollectionViewCell()
        
        if collectionView == todayCollectionView {
            bandCell = collectionView.dequeueReusableCell(withReuseIdentifier: bandVenueCellid, for: indexPath) as! BandVenueCollectionViewCell
            bandCell.venue = todayVenueArray[indexPath.row]
            return bandCell
        } else {
            print("Plain")
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        }
        
        
        return cell
    }
    
    
    
    
}
