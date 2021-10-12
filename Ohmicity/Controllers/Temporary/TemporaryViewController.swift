//
//  TemporaryViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/17/21.
//

import UIKit

class TemporaryViewController: UIViewController {
    
    //Properties
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.tintColor = UIColor.green
    }
    
    @IBAction func goBackButton(_ sender: Any) {
        tabBarController?.selectedIndex = 2
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
