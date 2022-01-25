//
//  ReloadAllDataViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/25/22.
//

import UIKit

class ReloadAllDataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        clearAllData()
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

//MARK: viewDidLoad Functions
extension ReloadAllDataViewController {
    
    private func clearAllData() {
        businessController.businessArray = []
        xityBusinessController.businessArray = []
        
        bandController.bandArray = []
        bandController.bandGroupArray = []
        xityBandController.bandArray = []
        
        showController.showArray = []
        showController.todayShowArray = []
        xityShowController.showArray = []
        xityShowController.weeklyPicksArray = []
        xityShowController.todayShowArray = []
        xityShowController.todayShowResultsArray = []
        xityShowController.xityShowSearchArray = []
        
        notificationCenter.post(notifications.reloadAllData)
    }
}
