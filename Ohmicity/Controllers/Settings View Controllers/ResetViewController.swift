//
//  ResetViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 5/20/21.
//

import UIKit
import MaterialComponents
import Firebase
class ResetViewController: UIViewController {
    
    //Properties
    @IBOutlet weak var emailButton: MDCButton!
    @IBOutlet weak var resetButton: MDCButton!
    
    @IBOutlet weak var emailTextField: MDCFilledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "UH OH!", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Got it!", style: .cancel, handler: nil)
        guard let email = emailTextField.text else {return}
        
        Auth.auth().currentUser?.updateEmail(to: email, completion: {[self] (error) in
            if let error = error {
                NSLog("Error updating email: \(error)")
                alert.message = "\(error.localizedDescription)"
                alert.addAction(alertAction)
                present(alert, animated: true) {
                    //Completion Handler
                }
            } else {
                NSLog("Check Your Email")
                alert.title = "Great!"
                alert.message = "Check \(email) for password reset instructions"
                alert.addAction(alertAction)
                present(alert, animated: true) {
                    //Completion Handler
                }
            }
        })
    }
    

    @IBAction func resetButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "UH OH!", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Got it!", style: .cancel, handler: nil)
        
        guard let email = Auth.auth().currentUser?.email else {return NSLog("No Email")}
        Auth.auth().sendPasswordReset(withEmail: email) { [self] (error) in
            if let error = error {
                NSLog("Error resetting password")
                alert.message = "\(error.localizedDescription)"
                alert.addAction(alertAction)
                present(alert, animated: true) {
                    //Completion Handler
                }
            } else {
                alert.title = "Great!"
                alert.message = "Check \(email) for password reset instructions"
                alert.addAction(alertAction)
                present(alert, animated: true) {
                    //Completion Handler
                }
            }
        }
    }
    
    private func updateViews() {
        //Buttons
        emailButton.layer.cornerRadius = 10
        emailButton.setTitle("Change Email Address", for: .normal)
        emailButton.backgroundColor = cc.mainColorPurple
        
        resetButton.layer.cornerRadius = 10
        resetButton.setTitle("Reset Password", for: .normal)
        resetButton.backgroundColor = cc.mainColorPurple
        
        //TextFields
        emailTextField.placeholder = "Type The New Email Here"
        emailTextField.leadingAssistiveLabel.text = "New Email Address"
        emailTextField.leadingAssistiveLabel.textColor = .white
        emailTextField.setFilledBackgroundColor(.clear, for: .normal)
        emailTextField.setFilledBackgroundColor(.clear, for: .editing)
        emailTextField.setTextColor(cc.mainColorPurple, for: .normal)
        emailTextField.setTextColor(cc.typingTextColorPurple, for: .editing)
        emailTextField.setUnderlineColor(cc.mainColorPurple, for: .normal)
        emailTextField.setUnderlineColor(cc.typingTextColorPurple, for: .editing)
        emailTextField.tintColor = cc.mainColorPurple
        
    }
}
