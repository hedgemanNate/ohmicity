//
//  ForgotPasswordViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 5/11/21.
//

import UIKit
import Firebase
import MaterialComponents

class ForgotPasswordViewController: UIViewController {

    //Properties
    @IBOutlet weak var emailTextField: MDCFilledTextField!
    @IBOutlet weak var sendEmailButton: MDCButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        //Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func sendEmailButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "UH OH!", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Got it!", style: .cancel, handler: nil)
        
        guard let email = emailTextField.text else {return}
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
        //TextField
        emailTextField.placeholder = "email@email.com"
        emailTextField.leadingAssistiveLabel.text = "Email"
        emailTextField.leadingAssistiveLabel.textColor = .white
        emailTextField.setFilledBackgroundColor(.clear, for: .normal)
        emailTextField.setFilledBackgroundColor(.clear, for: .editing)
        emailTextField.setTextColor(cc.mainColorPurple, for: .normal)
        emailTextField.setTextColor(cc.typingTextColorPurple, for: .editing)
        emailTextField.setUnderlineColor(cc.mainColorPurple, for: .normal)
        emailTextField.setUnderlineColor(cc.typingTextColorPurple, for: .editing)
        emailTextField.tintColor = cc.mainColorPurple
        
        //Button
        sendEmailButton.layer.cornerRadius = 10
        sendEmailButton.setTitle("Send Email", for: .normal)
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
