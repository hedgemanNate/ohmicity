//
//  MaintenanceModeViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 3/3/22.
//

import UIKit

class MaintenanceModeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotifyCenter.addObserver(self, selector: #selector(checkRemoteController), name: Notifications.remoteControlUpdated.name, object: nil)
    }
    
    
    @objc private func checkRemoteController() {
        if RemoteController.remoteModel.maintenanceMode == false {
            dismiss(animated: true)
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
