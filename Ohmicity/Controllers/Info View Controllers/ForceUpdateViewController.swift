//
//  ForceUpdateViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/16/22.
//

import UIKit

class ForceUpdateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func breaker(_ sender: Any) {
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
