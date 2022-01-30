//
//  RecommendViewController.swift
//  
//
//  Created by Nathan Hedgeman on 8/24/21.
//

import UIKit
import MaterialComponents
import FirebaseFirestore

class RecommendViewController: UIViewController {
    
    //Properties
    @IBOutlet weak var venueNameTextField: UITextField!
    @IBOutlet weak var explanationTextView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    //MARK: Button Actions
    @IBAction func sendButtonTapped(_ sender: Any) {
        guard let userID = currentUserController.currentUser?.userID else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
        }
        guard let venue = venueNameTextField.text else {return}
        guard let explain = explanationTextView.text else {return}
        if venue.count < 5 {
            venueNameTextField.text = "Name Must Be Longer!"
            return
        }
        if explain.count < 5 {
            explanationTextView.text = "Explanation Must Be Longer!"
            return
        }
        let rec = Recommendation(user: userID, businessName: venue, explanation: explain)
        
        do {
            try FireStoreReferenceManager.recommendationPath.document(rec.recommendationID).setData(from: rec, completion: { err in
                if let err = err {
                    NSLog(err.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                }
            })
        } catch let error {
            NSLog(error.localizedDescription)
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
    private func updateViews() {
        self.hideKeyboardWhenTappedAround()
        
        venueNameTextField.layer.borderColor = UIColor.white.cgColor
        venueNameTextField.layer.borderWidth = 1.5
        venueNameTextField.textColor = .white
        venueNameTextField.backgroundColor = cc.transBlack
        venueNameTextField.tintColor = cc.highlightBlue
        
        let estimatedFrame = CGRect(x: Double(explanationTextView.frame.minX), y: Double(explanationTextView.frame.minY), width: 302, height: -102)
        
        explanationTextView.frame = estimatedFrame
        explanationTextView.backgroundColor = cc.transBlack
        explanationTextView.layer.borderWidth = 1.5
        explanationTextView.layer.borderColor = UIColor.white.cgColor
        explanationTextView.textColor = .white
        explanationTextView.tintColor = cc.highlightBlue
        
//        //Temp Fix no user recommendation count
//        if currentUserController.currentUser?.recommendationCount == nil {
//            currentUserController.currentUser?.recommendationCount = 0
//        }
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
