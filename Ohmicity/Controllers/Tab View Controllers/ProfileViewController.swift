//
//  ProfileViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/8/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class ProfileViewController: UIViewController {
    
    //Properties
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    var timer = Timer()
    
    @IBOutlet private weak var bannerAdCollectionView: UICollectionView!
    @IBOutlet private weak var recommendButton: UIButton!
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var featureToggle: UIButton!
    var feature = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(updateLogButton), name: notifications.userAuthUpdated.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(endTimer), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(updateViews), name: notifications.userAuthUpdated.name, object: nil)
            
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLogButton()
        tabBarController?.tabBar.tintColor = UIColor.systemTeal
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    
    
    //MARK: ---- Functions ----
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "ToSignIn", sender: self)
        } else {
            do {
                try Auth.auth().signOut()
                currentUserController.currentUser = nil
                userAdController.userSubscription = .None
                self.tabBarController?.selectedIndex = 2
            } catch let signOutError as NSError {
                NSLog("Sign Out Failed: %@", signOutError)
            }
        }
    }
    
    @IBAction func privacyPolicyButtonTapped(_ sender: Any) {
        guard let url = URL(string: "https://face2faceapps.com/town-by-xity-app-privacy-policy/") else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func licenseAgreementButtonTapped(_ sender: Any) {
        guard let url = URL(string: "https://face2faceapps.com/town-by-xity-app-eula/") else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func featureToggleTapped(_ sender: Any) {
        notificationCenter.post(notifications.userAuthUpdated)
        
        
        if feature {
            currentUserController.currentUser?.subscription = .FullAccessPass
        } else {
            currentUserController.currentUser?.subscription = .None
        }
        
        feature.toggle()
        
        DispatchQueue.main.async { [self] in
            if feature == true {
            self.featureToggle.backgroundColor = .red
            } else {
                self.featureToggle.backgroundColor = .yellow
            }
        }
        
        print(subscriptionController.favorites, subscriptionController.seeAllData)
    }
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        if currentUserController.currentUser == nil {
            performSegue(withIdentifier: "ToSignIn", sender: self)
        } else {
            performSegue(withIdentifier: "ToSubscriptions", sender: self)
        }
        
        
    }
    
    
    
    @objc private func updateLogButton() {
        if Auth.auth().currentUser == nil {
            logoutButton.setTitle("Sign In", for: .normal)
        } else {
            logoutButton.setTitle("Sign Out", for: .normal)
        }
    }
    
    
    //MARK: UpdateViews
    @objc private func updateViews() {
        updateLogButton()
        setupCollectionsView()
        
        if currentUserController.currentUser == nil {
            recommendButton.isEnabled = false
            recommendButton.setTitle("Sign In To Recommend", for: .disabled)
            userIDLabel.text = "--"
        } else {
            recommendButton.isEnabled = true
            recommendButton.setTitle("Recommend", for: .normal)
            userIDLabel.text = currentUserController.currentUser?.userID ?? "--"
        }
        
        versionLabel.text = "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String) (\(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String))"
        
        versionLabel.text = "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "") \(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "")"
    }
    
    
    private func setupCollectionsView() {
        bannerAdCollectionView.dataSource = self
        bannerAdCollectionView.delegate = self
    }
    
    //MARK: Banner Ad
    @objc private func startTimer() {
        DispatchQueue.main.async {
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.bannerChange), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func endTimer() {
            timer.invalidate()
        }
    
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
    
    //MARK: ---- Functions End ----
}



//MARK: Collection View
extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case bannerAdCollectionView:
            //High Count For Infinite Loop: See Banner Ad Collection View & Banner Ad Section
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
            bannerAdCell.bannerAd = businessBannerAdController.businessAdArray[indexPath.row % businessBannerAdController.businessAdArray.count]
            return bannerAdCell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
