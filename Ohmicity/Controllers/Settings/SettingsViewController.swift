//
//  SettingsViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 5/14/21.
//

import UIKit
import MaterialComponents
import Firebase
class SettingsViewController: UIViewController {
    
    //Properties
    @IBOutlet weak var suggestButton: MDCButton!
    @IBOutlet weak var privacyButton: MDCButton!
    @IBOutlet weak var resetPasswordButton: MDCButton!
    @IBOutlet weak var logoutButton: MDCButton!
    
    let alert = UIAlertController(title: "Whoa Nelly!", message: "Having some trouble loggin you out. Give it a few and it try again.", preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Ok", style: .default)
    

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "ToMain", sender: self)
        } catch let signOutError as NSError {
            NSLog("\(signOutError)")
            alert.addAction(alertAction)
            present(alert, animated: true)
        }
    }
    
    //MARK: UI
    private func updateViews() {
        
        //Buttons
        suggestButton.setTitle("   Suggest A Business", for: .normal)
        suggestButton.backgroundColor = cc.mainColorPurple
        suggestButton.setImage(UIImage(systemName: "building"), for: .normal)
        suggestButton.setImageTintColor(.white, for: .normal)
        
        privacyButton.setTitle("   Privacy Policy", for: .normal)
        privacyButton.backgroundColor = cc.mainColorPurple
        privacyButton.setImage(UIImage(systemName: "doc.text"), for: .normal)
        privacyButton.setImageTintColor(.white, for: .normal)
        
        resetPasswordButton.setTitle("   Change Email/Reset Password", for: .normal)
        resetPasswordButton.backgroundColor = cc.mainColorPurple
        resetPasswordButton.setImage(UIImage(systemName: "lock.shield"), for: .normal)
        resetPasswordButton.setImageTintColor(.white, for: .normal)
        
        logoutButton.setTitle("   Logout", for: .normal)
        logoutButton.backgroundColor = cc.mainColorPurple
        logoutButton.setImage(UIImage(systemName: "arrowshape.turn.up.left"), for: .normal)
        logoutButton.setImageTintColor(.white, for: .normal)
    }
    
    
    @IBAction func privacyButtonTapped(_ sender: Any) {
        if let url = URL(string: "https://face2faceapps.com/super-hero-cpr-privacy-policy/") {
            UIApplication.shared.open(url)
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
