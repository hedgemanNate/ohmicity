//
//  PurchaseViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/8/21.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class PurchaseViewController: UIViewController {
    
    //Properties
    @IBOutlet weak var purchaseCollectionView: UICollectionView!
    var pass: SubscriptionType = .FrontRowPass
    
    //Buttons
    @IBOutlet weak var try7DaysFreeButton: UIButton!
    @IBOutlet weak var priceTextField: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    
    //Views
    var alert = UIAlertController()
    var alertAction = UIAlertAction()
    
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
    }
    
    //MARK: Button Actions
    
    @IBAction func breaker(_ sender: Any) {
        
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func try7DaysFreeButtonTapped(_ sender: Any) {
        PurchaseController.shared.purchase(pass: pass) { [self] success in
            if success == false {
                alert = UIAlertController(title: "There was an error with your payment.", message: "Do not worry. You were not charged. Please check your payment method and try again.", preferredStyle: .actionSheet)
                alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(alertAction)
                present(alert, animated: true, completion: nil)
            } else {
                alert = UIAlertController(title: "Success!", message: "You are now a Xity Pass Member! Thank you for supporting Live Local Music!!", preferredStyle: .actionSheet)
                alertAction = UIAlertAction(title: "Back To The Music", style: .default, handler: { _ in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
                alert.addAction(alertAction)
            }
        }
    }
    
    @IBAction func restorePurchaseButtonTapped(_ sender: Any) {
        PurchaseController.shared.restorePurchases { [self] success in
            if success == false {
                alert = UIAlertController(title: "Restore Failed", message: "Could not find a pass to restore.", preferredStyle: .actionSheet)
                alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(alertAction)
                present(alert, animated: true, completion: nil)
            } else {
                alert = UIAlertController(title: "Pass Restored", message: "Your Xity Pass has been restored.", preferredStyle: .actionSheet)
                alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(alertAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func listOfPassFeaturesButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func pageControllerValueChanged(_ sender: Any) {
        
    }
    
    
    
    //MARK: UpdateViews
    private func updateViews() {
        try7DaysFreeButton.layer.cornerRadius = 6
    }
    
    private func initSubscriptionType() {
        if currentUserController.currentUser != nil && currentUserController.currentUser?.subscription == nil {
            currentUserController.currentUser?.subscription = .None
            
            do {
                currentUserController.currentUser?.lastModified = Timestamp()
                try ref.userDataPath.document(currentUserController.currentUser!.userID).setData(from: currentUserController.currentUser)
            } catch {
                NSLog("Error setting subscriptionType to currentUser in Firebase: PurchaseViewController")
            }
            
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: Collection VIew
extension PurchaseViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriptionController.inAppPurchaseArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PurchaseCell", for: indexPath) as? PurchaseCollectionViewCell else {return UICollectionViewCell()}
        
        cell.purchaseOption = subscriptionController.inAppPurchaseArray[indexPath.row]
        
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

//MARK: Purchase Network Calls
extension PurchaseViewController {
    
    
}
