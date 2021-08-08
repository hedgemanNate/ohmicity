//
//  SearchViewController.swift
//  Ohmicity
//
//  Created by Nate Hedgeman on 5/6/21.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    //Properties
    var resultsArray = [XityShow]()
    var city: City? {
        didSet {
            startSearch()
        }
    }
    var businessType: BusinessType? {
        didSet {
            startSearch()
        }
    }
    var genre: Genre? {
        didSet {
            startSearch()
        }
    }
    
    
    var timer = Timer()
    
    @IBOutlet weak var bannerAdCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCollectionViews()
        updateViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
}


//MARK: Functions
extension SearchViewController {
    
    private func setUpCollectionViews() {
        bannerAdCollectionView.delegate = self
        bannerAdCollectionView.dataSource = self
    }
    
    private func startSearch() {
        
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        let op1 = BlockOperation {
            if self.city != nil {
                self.resultsArray = xityShowController.xityShowSearchArray.filter({ xityShow in
                    if xityShow.business.city.contains(self.city!) {
                        return true
                    }
                    return false
                })
            } else {return}
        }
        
        let op2 = BlockOperation {
            if self.businessType != nil && self.resultsArray.count != 0 {
                self.resultsArray = self.resultsArray.filter({ xityShow in
                    if xityShow.business.businessType.contains(self.businessType!) {
                        return true
                    }
                    return false
                })
            } else if self.businessType != nil {
                self.resultsArray = xityShowController.xityShowSearchArray.filter({ xityShow in
                    if xityShow.business.businessType.contains(self.businessType!) {
                        return true
                    }
                    return false
                })
            } else {return}
        }
        
        let op3 = BlockOperation {
            if self.genre != nil && self.resultsArray.count != 0 {
                self.resultsArray = self.resultsArray.filter({ xityShow in
                    if xityShow.band.genre.contains(self.genre!) {
                        return true
                    }
                    return false
                })
            } else if self.genre != nil {
                self.resultsArray = xityShowController.xityShowSearchArray.filter({ xityShow in
                    if xityShow.band.genre.contains(self.genre!) {
                        return true
                    }
                    return false
                })
            } else {return}
        }
        
        let op4 = BlockOperation {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        op4.addDependency(op3)
        op3.addDependency(op2)
        op2.addDependency(op1)
        opQueue.addOperations([op1, op2, op3, op4], waitUntilFinished: true)
    }
    
    //MARK: - UpdateViews
    private func updateViews() {
        
    }
    
    @objc private func slideChange() {
        let shownPath = bannerAdCollectionView.indexPathsForVisibleItems
        let currentPath = shownPath.first
        
        var indexPath = IndexPath(row: currentPath!.row + 1, section: 0)
        
        //High Count For Infinite Loop: See Banner Ad Collection View
        if currentPath!.row < 50 {
            self.bannerAdCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        } else {
            indexPath = IndexPath(row: 0, section: 0)
            self.bannerAdCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
}


//MARK: Collection View
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        
        switch collectionView {
        case bannerAdCollectionView:
            size = CGSize(width: width, height: height)
            return size
        default:
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case bannerAdCollectionView:
            bannerAdController.bannerAdArray.shuffle()
            return 50
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var bannerAdCell = BannerAdBusinessPicsCollectionViewCell()
        
        switch collectionView {
        case bannerAdCollectionView:
            bannerAdCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerAdCell", for: indexPath) as! BannerAdBusinessPicsCollectionViewCell
            //% for indexPath to allow for infinite loop: See Banner Ad Section
            bannerAdCell.bannerAd = bannerAdController.bannerAdArray[indexPath.row % bannerAdController.bannerAdArray.count]
            return bannerAdCell
            
        default:
            return UICollectionViewCell()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    //Leaving off: startSearch function "finished". Finish setting up table view and test startSearch Function
}
