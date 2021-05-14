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
        
        suggestButton.setTitle("Suggest A Business", for: .normal)
        suggestButton.backgroundColor = cc.mainColorPurple
        
        privacyButton.setTitle("Privacy Policy", for: .normal)
        privacyButton.backgroundColor = cc.mainColorPurple
        
        resetPasswordButton.setTitle("Reset Password/Change Email", for: .normal)
        resetPasswordButton.backgroundColor = cc.mainColorPurple
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = cc.mainColorPurple
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
