//
//  ShutDownViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 3/3/22.
//

import UIKit

class ShutDownViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotifyCenter.addObserver(self, selector: #selector(checkRemoteController), name: Notifications.remoteControlUpdated.name, object: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func shutDownButtonTapped(_ sender: Any) {
        let deadline = DispatchTime.now() + .seconds(2)
        UIScreen.main.brightness = 0.1
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            exit(0)
        }
        
    }
    
    @objc private func checkRemoteController() {
        if RemoteController.remoteModel.shutDown == false {
            dismiss(animated: true)
        }
        
    }
    
}
