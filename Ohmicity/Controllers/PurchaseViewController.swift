//
//  PurchaseViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/8/21.
//

import UIKit

class PurchaseViewController: UIViewController {
    //Properties
    
    @IBOutlet weak var purchaseCollectionView: UICollectionView!
    
    //Buttons
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var try7DaysFreeButton: UIButton!
    @IBOutlet weak var priceTextField: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        setupCollectionView()
    }
    
    //MARK: Button Actions
    @IBAction func dismissButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func try7DaysFreeButtonTapped(_ sender: Any) {
    }
    
    @IBAction func pageControllerValueChanged(_ sender: Any) {
        switch pageController.currentPage {
        case 1:
            priceTextField.text = "Then $1.99 per month. Cancel Anytime."
        case 2:
            priceTextField.text = "Then $4.99 per month. Cancel Anytime."
        case 3:
            priceTextField.text = "Then $6.99 per month. Cancel Anytime."
        default:
            break
        }
    }
    
    
    
    //MARK: UpdateViews
    private func updateViews() {
        try7DaysFreeButton.layer.cornerRadius = 25
        
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PurchaseCell", for: indexPath) as? PurchaseCollectionViewCell else {return UICollectionViewCell()}
        
        cell.purchaseOption = subscriptionTypeController.inAppPurchaseArray[indexPath.row]
        
        return cell
    }
    
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        switch scrollView {
        case purchaseCollectionView:
            let x = targetContentOffset.pointee.x
            pageController.currentPage = Int(x / view.frame.width)
        default:
            break
        }
        
    }
    
}
