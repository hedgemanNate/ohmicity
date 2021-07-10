//
//  SignUpViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 5/10/21.
//

import UIKit
import Firebase
import MaterialComponents


class SignUpViewController: UIViewController {
    
    //Properties
    @IBOutlet weak var signUpButton: MDCButton!
    @IBOutlet weak var signInButton: MDCButton!
    @IBOutlet weak var emailTextField: MDCFilledTextField!
    @IBOutlet weak var passwordTextField: MDCFilledTextField!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        //Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        emailTextField.addTarget(self, action: #selector(emailNextTapped), for: UIControl.Event.editingDidEndOnExit)
        passwordTextField.addTarget(self, action: #selector(passwordDoneTapped), for: UIControl.Event.editingDidEndOnExit)
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func goBackButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Sign Up/In
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text else {return NSLog("No email Address")}
        guard let password = passwordTextField.text else {return NSLog("No password")}
        
        let alert = UIAlertController(title: "UH OH!", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Got it!", style: .cancel, handler: nil)
        let alertAction2 = UIAlertAction(title: "Ok", style: .default) { [self] (_) in
            notificationCenter.post(notifications.userAuthUpdated)
            notificationCenter.post(notifications.scrollToTop)
            dismiss(animated: true, completion: nil)
        }
        
        Auth.auth().createUser(withEmail: email, password: password)  { [self] (authResult, error) in
            if let error = error {
                NSLog("Error Logging In: \(error)")
                alert.message = error.localizedDescription
                alert.addAction(alertAction)
                alertUI(alert)
                present(alert, animated: true, completion: nil)
            } else {
                guard let uid = authResult?.user.uid else {return NSLog("No uid returned from auth")}
                guard let email = authResult?.user.email else {return NSLog("No email retuned from auth")}
                currentUser = CurrentUser(userID: uid, email: email)
                alert.title = "Welcome!"
                alert.message = "Sign Up Successful"
                alertUI(alert)
                alert.addAction(alertAction2)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        let alert = UIAlertController(title: "UH OH!", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Got it!", style: .cancel, handler: nil)
        
        Auth.auth().signIn(withEmail: email, password: password) { [self] (authDataResult, error) in
            if let error = error {
                NSLog("Error signing in. \(error)")
                alert.message = error.localizedDescription
                alert.addAction(alertAction)
                alertUI(alert)
                present(alert, animated: true, completion: nil)
            } else {
                guard let uid = authDataResult?.user.uid else {return NSLog("No uid returned from auth")}
                guard let email = authDataResult?.user.email else {return NSLog("No email returned from auth")}
                currentUser = CurrentUser(userID: uid, email: email)
                notificationCenter.post(notifications.userAuthUpdated)
                notificationCenter.post(notifications.scrollToTop)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: UI
    private func updateViews() {
        //Buttons
        goBackButton.setTitleColor(.white, for: .normal)
        
        signInButton.layer.cornerRadius = 10
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.backgroundColor = cc.mainColorPurple
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = cc.secondaryColorPurple
        
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        
        //TextFields
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
        
        passwordTextField.placeholder = "kFe6*vm^84"
        passwordTextField.leadingAssistiveLabel.text = "Password"
        passwordTextField.leadingAssistiveLabel.textColor = .white
        passwordTextField.setFilledBackgroundColor(.clear, for: .normal)
        passwordTextField.setFilledBackgroundColor(.clear, for: .editing)
        passwordTextField.setTextColor(cc.mainColorPurple, for: .normal)
        passwordTextField.setTextColor(cc.typingTextColorPurple, for: .editing)
        passwordTextField.setUnderlineColor(cc.mainColorPurple, for: .normal)
        passwordTextField.setUnderlineColor(cc.typingTextColorPurple, for: .editing)
        passwordTextField.tintColor = cc.mainColorPurple
        
        //Keyboards
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        
    }
    
    private func alertUI(_ alert: UIAlertController) {
        alert.view.layer.cornerRadius = 30
        alert.view.clipsToBounds = true
        alert.view.layer.borderWidth = 5
        alert.view.layer.borderColor = cc.secondaryColorPurple.cgColor
        alert.setBackgroundColor(color: cc.mainColorPurple)
        alert.setTitle(font: UIFont.boldSystemFont(ofSize: 22), color: .white)
        alert.setMessage(font: UIFont.systemFont(ofSize: 16), color: .white)
        alert.setTint(color: .white)
        
        
    }
    
    //Keyboard
    @objc func emailNextTapped() {
        passwordTextField.becomeFirstResponder()
    }
    
    @objc func passwordDoneTapped() {
        passwordTextField.endEditing(true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prep are(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
