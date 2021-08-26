//
//  RecommendViewController.swift
//  
//
//  Created by Nathan Hedgeman on 8/24/21.
//

import UIKit
import MaterialComponents
import MaterialComponents.MaterialTextFields
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import FirebaseFirestore

class RecommendViewController: UIViewController {
    
    //Properties
    @IBOutlet weak var venueNameTextField: MDCFilledTextField!
    @IBOutlet weak var explanationTextView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    let db = Firestore.firestore().collection("remoteData").document("remoteData").collection("recommendationData")
    let userDB = Firestore.firestore().collection("remoteData").document("remoteData").collection("userData")

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    
    
    
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        let currentUser = currentUserController.currentUser
        
        if currentUserController.currentUser!.recommendationCount! <= 10 {
            guard let user = currentUserController.currentUser?.userID else {return}
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
            let rec = Recommendation(user: user, businessName: venue, explanation: explain)
            
            let pushData = BlockOperation { [self] in
                do {
                    try db.document(rec.recommendationID.uuidString).setData(from: rec)
                } catch let error {
                    NSLog("Error pushing recommendation to database: \(error.localizedDescription)")
                    //Place An Alert
                }
            }
            
            let dismissView = BlockOperation { [self] in
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        currentUser?.recommendationCount! += 1
                        userDB.document(user).updateData(["recommendationCount" : currentUser!.recommendationCount!])
                    }
                }
            }
            
            if (venueNameTextField.text?.localizedCaseInsensitiveContains("Name Must Be Longer!"))! || explanationTextView.text.localizedCaseInsensitiveContains("Explanation Must Be Longer!") {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            dismissView.addDependency(pushData)
            opQueue.addOperations([pushData, dismissView], waitUntilFinished: true)
            
        } else {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func updateViews() {
        self.hideKeyboardWhenTappedAround()
        
        venueNameTextField.label.text = "Business Name And City"
        venueNameTextField.textColor = .white
        venueNameTextField.setFilledBackgroundColor(cc.transBlack, for: .editing)
        venueNameTextField.setFilledBackgroundColor(cc.transBlack, for: .normal)
        venueNameTextField.tintColor = cc.highlightBlue
        
        let estimatedFrame = CGRect(x: Double(explanationTextView.frame.minX), y: Double(explanationTextView.frame.minY), width: 302, height: -102)
        
        explanationTextView.frame = estimatedFrame
        explanationTextView.backgroundColor = cc.transBlack
        explanationTextView.layer.borderWidth = 1.5
        explanationTextView.layer.borderColor = UIColor.white.cgColor
        explanationTextView.textColor = .white
        explanationTextView.tintColor = cc.highlightBlue
        
        //Temp Fix no user recommendation count
        if currentUserController.currentUser?.recommendationCount == nil {
            currentUserController.currentUser?.recommendationCount = 0
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
