//
//  SupportInfoViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/17/21.
//

import UIKit
import MaterialComponents.MDCActivityIndicator

class SupportInfoViewController: UIViewController {

    //Properties
    let supportIndicator4 = MDCActivityIndicator()
    @IBOutlet weak var supportIndicatorView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        supportIndicatorSetup()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func supportIndicatorSetup() {
        supportIndicator4.setProgress(0.15, animated: true)
        supportIndicatorView.addSubview(supportIndicator4)
        supportIndicator4.startAnimating()
        
        //SupportIndicator 4 UI
        supportIndicator4.indicatorMode = .indeterminate
        supportIndicator4.radius = supportIndicatorView.frame.height / 2.5
        supportIndicator4.cycleColors = [.systemPurple, .systemOrange, .systemGreen, .systemTeal, .systemYellow]
        supportIndicator4.strokeWidth = 3
        supportIndicator4.trackEnabled = false
        
        
        supportIndicator4.translatesAutoresizingMaskIntoConstraints = false
        supportIndicator4.centerXAnchor.constraint(equalTo: supportIndicatorView.centerXAnchor).isActive = true
        supportIndicator4.centerYAnchor.constraint(equalTo: supportIndicatorView.centerYAnchor).isActive = true
    }
}
