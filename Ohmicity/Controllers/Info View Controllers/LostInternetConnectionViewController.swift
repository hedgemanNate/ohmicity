//
//  LostInternetConnectionViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/23/21.
//

import UIKit
import MaterialComponents.MDCActivityIndicator

class LostInternetConnectionViewController: UIViewController {

    //Properties
    let activityIndicator = MDCActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupProgressView()
        notificationCenter.addObserver(self, selector: #selector(dismissView), name: notifications.hasConnection.name, object: nil)
    }
    
    
    //Functions
    private func setupProgressView() {
        activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 1)
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.radius = 150
        activityIndicator.cycleColors = [cc.highlightBlue, UIColor.yellow, UIColor.systemPurple, UIColor.green]
        activityIndicator.startAnimating()
    }
    
    @objc private func dismissView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
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
