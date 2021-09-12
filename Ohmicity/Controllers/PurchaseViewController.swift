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
    
    //Buttons
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var try7DaysFreeButton: UIButton!
    @IBOutlet weak var priceTextField: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    
    //Views
    var purchaseDetailsSet: Int? {
        didSet {
            print(purchaseDetailsSet!)
            DispatchQueue.main.async { [self] in
                switch purchaseDetailsSet {
                case 0:
                    priceTextField.text = "Then $1.99 per month. Cancel Anytime."
                case 347:
                    priceTextField.text = "Then $4.99 per month. Cancel Anytime."
                case 2:
                    priceTextField.text = "Then $6.99 per month. Cancel Anytime."
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
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func try7DaysFreeButtonTapped(_ sender: Any) {
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
        return subscriptionTypeController.inAppPurchaseArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PurchaseCell", for: indexPath) as? PurchaseCollectionViewCell else {return UICollectionViewCell()}
        
        cell.purchaseOption = subscriptionTypeController.inAppPurchaseArray[indexPath.row]
        
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
