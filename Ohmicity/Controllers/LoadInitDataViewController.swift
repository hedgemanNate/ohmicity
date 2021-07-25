//
//  LoadInitDataViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/14/21.
//

import UIKit

class LoadInitDataViewController: UIViewController {
    
    //Properties
    @IBOutlet var btn: UIButton!
    var databaseCount = 0 {
        didSet {
            if databaseCount == 3 {
                doneLoading()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Cache Loading Notifications
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotCacheShowData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotCacheBandData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotCacheBusinessData.name, object: nil)
        
        //Database Loading Notifications
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotShowData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotBandData.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(counting), name: notifications.gotBusinessData.name, object: nil)
        
        lmDateHandler.checkDateAndGetData()
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btn(_ sender: Any) {
        
        print("tapped")
    }
    
    @objc private func counting() {
        databaseCount += 1
        print(databaseCount)
    }
    
    
    private func doneLoading() {
        print(showController.showArray)
        self.performSegue(withIdentifier: "ToDashboard", sender: self)
    }
}
