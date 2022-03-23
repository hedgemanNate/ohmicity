//
//  PurchaseViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/8/21.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import RevenueCat


class PurchaseViewController: UIViewController {
    
    
    //Properties
    @IBOutlet weak var purchaseCollectionView: UICollectionView!
    var pass: SubscriptionType = .FrontRowPass
    private var subscription: SubscriptionType?
    
    //Buttons
    @IBOutlet weak var try7DaysFreeButton: UIButton!
    @IBOutlet weak var priceTextField: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    
    //Views
    var alert = UIAlertController()
    var alertAction = UIAlertAction()
    var numberOfPages = 0
    
    @IBOutlet weak var bottomButtonStackView: UIStackView!
    @IBOutlet weak var bottomTextView: UITextView!
    
    
    
    var purchaseDetailsSet: Int? {
        didSet {
            print(purchaseDetailsSet!)
            DispatchQueue.main.async { [self] in
                switch purchaseDetailsSet {
                case 0:
                    priceTextField.text = "Then $2.99 per month. Cancel Anytime."
                    pass = .FrontRowPass
                case 345:
                    priceTextField.text = "Then $4.99 per month. Cancel Anytime."
                    pass = .BackStagePass
                case 2:
                    priceTextField.text = "Then $6.99 per month. Cancel Anytime."
                    pass = .FullAccessPass
                default:
                    break
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        initSubscriptionType()
        setupCollectionView()
        updateViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SubscriptionController.inAppPurchaseArray.removeAll()
    }
    
    //MARK: Button Actions
    
    @IBAction func breaker(_ sender: Any) {
        purchaseCollectionView.reloadData()
    }
    
    //MARK: UpdateViews
    private func updateViews() {
        try7DaysFreeButton.layer.cornerRadius = 6
        numberOfPages = SubscriptionController.inAppPurchaseArray.count
        pageController.numberOfPages = numberOfPages
        purchaseCollectionView.reloadData()
        self.purchaseCollectionView.isHidden = false
        self.bottomButtonStackView.isHidden = false
        self.bottomTextView.isHidden = false
        self.pageController.isHidden = false
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func try7DaysFreeButtonTapped(_ sender: Any) {
        let index = pageController.currentPage
        let package = SubscriptionController.packages[index]
        
        Purchases.shared.purchase(package: package) { (transaction, customerInfo, error, userCancelled) in
            if customerInfo?.entitlements["com.townbyxity.noads"]?.isActive == true {
            print("Purchase is working")
          }
        }
        if index == 0 {subscription = .FrontRowPass}
    }
    
    @IBAction func restorePurchaseButtonTapped(_ sender: Any) {
//        PurchaseController.shared.restorePurchases { [self] success in
//            if success == false {
//                alert = UIAlertController(title: "Restore Failed", message: "Could not find a pass to restore.", preferredStyle: .actionSheet)
//                alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//                alert.addAction(alertAction)
//                present(alert, animated: true, completion: nil)
//            } else {
//                alert = UIAlertController(title: "Pass Restored", message: "Your Xity Pass has been restored.", preferredStyle: .actionSheet)
//                alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//                alert.addAction(alertAction)
//                present(alert, animated: true, completion: nil)
//            }
//        }
    }
    
    
    @IBAction func listOfPassFeaturesButtonTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func pageControllerValueChanged(_ sender: Any) {
        
    }
    
    
    //MARK: Functions
    private func setupCollectionView() {
        purchaseCollectionView.delegate = self
        purchaseCollectionView.dataSource = self
        
        //Centers the collection view cells
        let collectionViewLayout = purchaseCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let inset = (self.view.frame.width - 300) / 2
        collectionViewLayout?.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        collectionViewLayout?.invalidateLayout()
    }
    
    private func fetchProducts() {
        Purchases.shared.getOfferings { offerings, err in
            if let err = err {
                NSLog("🚨 Error getting products from Revenue Cat: \(err.localizedDescription)")
            }
            if let packages = offerings?.offering(identifier: "com.townbyxity.noads")?.availablePackages {
                for pack in packages {
                    
                    switch pack.offeringIdentifier{
                    case "com.townbyxity.noads":
                        let noAds = Subscription(type: .FrontRowPass, description: pack.description, features: [SubscriptionController.noAdsFeature, SubscriptionController.memberAccess], price: pack.localizedPriceString)
                        SubscriptionController.inAppPurchaseArray.append(noAds)
                    case "com.townbyxity.deals":
                        
                        let deals = Subscription(type: .BackStagePass, description: pack.description, features: [SubscriptionController.noAdsFeature, SubscriptionController.memberAccess, /*Xity Deals*/], price: pack.localizedPriceString)
                        SubscriptionController.inAppPurchaseArray.append(deals)
                    default:
                        break
                    }
                }
            }
            self.numberOfPages = SubscriptionController.inAppPurchaseArray.count
            DispatchQueue.main.async {
                self.purchaseCollectionView.reloadData()
            }
        }
    }
    
    private func initSubscriptionType() {
        if currentUserController.currentUser != nil && currentUserController.currentUser?.subscription == nil {
            currentUserController.currentUser?.subscription = .None
            
            do {
                currentUserController.currentUser?.lastModified = Timestamp()
                try FireStoreReferenceManager.userDataPath.document(currentUserController.currentUser!.userID).setData(from: currentUserController.currentUser)
            } catch {
                NSLog("Error setting subscriptionType to currentUser in Firebase: PurchaseViewController")
            }
            
        }
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
extension PurchaseViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PurchaseCell", for: indexPath) as? PurchaseCollectionViewCell else {return UICollectionViewCell()}
        
        cell.purchaseOption = SubscriptionController.inAppPurchaseArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 45
    }
    
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        switch scrollView {
        case purchaseCollectionView:
            
            //Page Controller Code
            let x = targetContentOffset.pointee.x
            let num = x.rounded(.awayFromZero)
            print(num)
            purchaseDetailsSet = Int(num)
            pageController.currentPage = Int(num)
           
        default:
            break
        }
    }
}

//MARK: Product Purchase Functions
extension PurchaseViewController {
    
    private func setUserSubscriptionFor(_ subscription: SubscriptionType) {
        //Set the current users new subscription
        guard let user = currentUserController.currentUser else {return}
        user.subscription = subscription
        do {
            try FireStoreReferenceManager.userDataPath.document(user.userID).setData(from: user, completion: { error in
                if let error = error {
                    NSLog(error.localizedDescription)
                } else {
                    currentUserController.currentUser?.subscription = user.subscription
                    NotifyCenter.post(Notifications.userSubscriptionUpdated)
                }
            })
        } catch (let error) {
            NSLog(error.localizedDescription)
        }
        
        //update the available features
        //SubscriptionController.noPopupAds = true
    }
    
}
