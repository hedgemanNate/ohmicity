//
//  ProfileViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/8/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProfileViewController: UIViewController {
    
    //Properties
    @IBOutlet weak var logoutButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(updateLogButton), name: notifications.userAuthUpdated.name, object: nil)
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLogButton()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "ToSignIn", sender: self)
        } else {
            do {
                try Auth.auth().signOut()
                notificationCenter.post(notifications.userAuthUpdated)
                self.tabBarController?.selectedIndex = 0
            } catch let signOutError as NSError {
                NSLog("Sign Out Failed: %@", signOutError)
            }
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
    
    @objc private func updateLogButton() {
        if Auth.auth().currentUser == nil {
            logoutButton.setTitle("Sign In", for: .normal)
        } else {
            logoutButton.setTitle("Sign Out", for: .normal)
        }
    }
    
    private func updateViews() {
        updateLogButton()
    }

}
