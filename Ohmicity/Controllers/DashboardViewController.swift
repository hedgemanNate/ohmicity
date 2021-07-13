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
    @IBOutlet weak var getPerksButton: UIButton!
    @IBOutlet weak var alreadyAccountButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topAdView: UIView!
    
    
    //Hidden Elements
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    @IBOutlet weak var hiddenSignUpView: UIView!
    
    //Collections Views
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
    
   
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationObservers()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        ref.businessFullDataPath.whereField("name", isEqualTo: "Banana Factory").getDocuments(source: .cache, completion: { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                for document in querySnapshot!.documents {
                    let result = Result {
                        try document.data(as: BusinessFullData.self)
                    }
                    switch result {
                    case .success(let business):
                        if let business = business {
                            print(business.name)
                        } else {
                            print("Not Found")
                        }
                    case .failure(_):
                        print("error")
                    }
                }
            }
        })
        
    }
    
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
    
    private func updateViews() {
        handleHidden()
    }
    
    private func notificationObservers() {
        //Hide Views
        notificationCenter.addObserver(self, selector: #selector(handleHidden), name: notifications.userAuthUpdated.name, object: nil)
        
        //Scroll To Top
        notificationCenter.addObserver(self, selector: #selector(scrollToTop), name: notifications.scrollToTop.name, object: nil)
    }
    
    //MARK:Cache Data
    private func getCacheBusinessData() {
        
    }

}
