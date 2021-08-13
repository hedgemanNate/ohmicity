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

        businessType = BusinessType.Outdoors
        
        setUpCollectionViews()
        updateViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    
    //MARK: Buttons Tapped
    
    @IBAction func breaker(_ sender: Any) {
        
    }
    
    
    
}




//MARK: Functions
extension SearchViewController {
    
    private func setUpCollectionViews() {
        bannerAdCollectionView.delegate = self
        bannerAdCollectionView.dataSource = self
    }
    
    private func startSearch() {
        print("SEARCH STARTED!!!!!!!")
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        let cityOp = BlockOperation {
            print("op1")
            if self.city != nil {
                print("op1 !=nil")
                self.resultsArray = xityShowController.showArray.filter({ xityShow in
                    if xityShow.business.city.contains(self.city!) {
                        return true
                    }
                    return false
                })
            } else {return print("op1 return")}
        }
        
        let businessTypeOP = BlockOperation {
            print("op2")
            if self.businessType != nil && self.resultsArray.count != 0 {
                print("op2 !=nil&&")
                self.resultsArray = self.resultsArray.filter({ xityShow in
                    if xityShow.business.businessType.contains(self.businessType!) {
                        return true
                    }
                    return false
                })
            } else if self.businessType != nil {
                print("op2 !=nil")
                self.resultsArray = xityShowController.showArray.filter({ xityShow in
                    if xityShow.business.businessType.contains(self.businessType!) {
                        print(xityShow)
                        return true
                    }
                    return false
                })
            } else {return print("return")}
        }
        
        let genreOp = BlockOperation {
            print("op3")
            if self.genre != nil && self.resultsArray.count != 0 {
                print("op3 !=nil&&")
                let tempArray = self.resultsArray.filter({ xityShow in
                    if xityShow.band.genre.contains(self.genre!) {
                        return true
                    }
                    return false
                })
                self.resultsArray = tempArray
            } else if self.genre != nil {
                print("op3 !=nil")
                self.resultsArray = xityShowController.xityShowSearchArray.filter({ xityShow in
                    if xityShow.band.genre.contains(self.genre!) {
                        return true
                    }
                    return false
                })
            } else {return print("op3 return")}
        }
        
        let op4 = BlockOperation {
            print("op4")
            DispatchQueue.main.async {
                print("op4")
                self.tableView.reloadData()
            }
        }
        
        op4.addDependency(genreOp)
        genreOp.addDependency(businessTypeOP)
        businessTypeOP.addDependency(cityOp)
        opQueue.addOperations([cityOp, businessTypeOP, genreOp, op4], waitUntilFinished: true)
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
            //% for indexpath to allow for infinite loop: See Banner Ad Section
            bannerAdCell.bannerAd = bannerAdController.bannerAdArray[indexPath.row % bannerAdController.bannerAdArray.count]
            return bannerAdCell
            
        default:
            return UICollectionViewCell()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
        
        cell.xityBusinessShow = resultsArray[indexPath.row]
        
        return cell
    }
    
    //Leaving off: startSearch function "finished". Finish setting up table view and test startSearch Function
}
