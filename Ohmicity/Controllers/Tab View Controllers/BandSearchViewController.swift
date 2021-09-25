//
//  BandSearchViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/23/21.
//

import UIKit

class BandSearchViewController: UIViewController {
    
    //Properties
    var bandResultsArray = [XityBand]()
    var bandArray = xityBandController.bandArray
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerAdCollectionView: UICollectionView!
    
    //Banner
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.tintColor = UIColor.yellow
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        endTimer()
    }
    
    
    private func setUpCollectionAndTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        bandResultsArray = bandArray
        bandResultsArray.sort(by: {$0.band.name < $1.band.name})
        bandResultsArray.sort(by: {($0.band.photo != nil) && ($1.band.photo == nil)})
        
        bannerAdCollectionView.dataSource = self
        bannerAdCollectionView.delegate = self
        
        
    }

    //MARK: UpdateViews
    private func updateViews() {
        setUpCollectionAndTableView()
        hideKeyboardWhenTappedAround()
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        endTimer()
        if segue.identifier == "BandSegue" {
            guard let bandDetailVC = segue.destination as? BandDetailViewController else {return}
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let band = bandResultsArray[indexPath.row]
            bandDetailVC.currentBand = band
        }
    }
}


//MARK: TableView
extension BandSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bandResultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
        
        cell.xityBand = bandResultsArray[indexPath.row]
        
        return cell
    }
    
    
    
    
}


//MARK: CollectionView
extension BandSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        
        size.height = height
        size.width = width
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //bannerAd Config
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var bannerAdCell = BannerAdBusinessPicsCollectionViewCell()
        bannerAdCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerAdCell", for: indexPath) as! BannerAdBusinessPicsCollectionViewCell
        //% for indexpath to allow for infinite loop: See Banner Ad Section
        bannerAdCell.bannerAd = businessBannerAdController.businessAdArray[indexPath.row % businessBannerAdController.businessAdArray.count]
        return bannerAdCell
    }
    
    
}