//
//  UpdateAvailableViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/29/22.
//

import UIKit
import MaterialComponents.MaterialActivityIndicator
import MaterialComponents.MaterialProgressView
import MaterialComponents

class UpdateAvailableViewController: UIViewController {
    //MARK: Properties
    
    @IBOutlet weak var versionLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       updateViews()
    }
    
    
    private func updateViews() {
        versionLabel.text = "Version \(CheckForUpdateController.appStoreVersion)"
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        guard let url = URL(string: "https://apps.apple.com/us/app/town-by-xity/id1582040816") else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
