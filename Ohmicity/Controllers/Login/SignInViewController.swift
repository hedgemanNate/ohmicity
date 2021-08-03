//
//  SignInViewController.swift
//  Ohmicity
//
//  Created by Nate Hedgeman on 5/4/21.
//

import UIKit
import FirebaseOAuthUI
import MaterialComponents

class SignInViewController: UIViewController, FUIAuthDelegate {

    //Properties
    @IBOutlet weak var appleSignInButton: MDCButton!
    @IBOutlet weak var signUpButton: MDCButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        addUserListener()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        Auth.auth().removeStateDidChangeListener(authHandle!)
    }
    
    //MARK: Auth
    @IBAction func signInButtonTapped(_ sender: Any) {
        if let authUI = FUIAuth.defaultAuthUI() {
            authUI.providers = [FUIOAuth.appleAuthProvider()]
            authUI.delegate = self
            
            let authViewController = authUI.authViewController()
            self.present(authViewController, animated: true)
        }
    }
    
    internal func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user {
            print("\(user.uid) is the user signed in")
            guard let uid = authDataResult?.user.uid else {return NSLog("No uid returned from auth")}
            guard let email = authDataResult?.user.email else {return NSLog("No email retuned from auth")}
            
            
            
            currentUser = User(userID: uid, email: email)
            notificationCenter.post(notifications.userAuthUpdated)
            self.dismiss(animated: true, completion: nil)
            

        }
    }
    
    @IBAction func breaker(_ sender: Any) {

    }
    
    func addUserListener() {
        authHandle = Auth.auth().addStateDidChangeListener { [self] (auth, user) in
            if user == nil {
                //Future function for no user signed in
                print("NO USERS SIGN IN!!!!!!!")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
      }
    }
    
    //MARK: UI
    private func updateViews() {
        //Buttons
        appleSignInButton.layer.cornerRadius = 10
        appleSignInButton.setTitle("Sign In With Apple", for: .normal)
        appleSignInButton.backgroundColor = cc.mainColorPurple
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.setTitle("Sign In With Email", for: .normal)
        signUpButton.backgroundColor = cc.secondaryColorPurple
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
