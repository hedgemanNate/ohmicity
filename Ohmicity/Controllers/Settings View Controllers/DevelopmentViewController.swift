//
//  DevelopmentViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/28/22.
//

import UIKit

class DevelopmentViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var adsSwitch: UISwitch!
    @IBOutlet weak var databaseSeg: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DevelopmentSettingsController.loadDevData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViews()
    }
    
    //MARK: UpdateViews
    private func updateViews() {
        if DevelopmentSettingsController.devSettings.ads == false {
            adsSwitch.isOn = false
        } else {
            adsSwitch.isOn = true
        }
        
        if DevelopmentSettingsController.devSettings.database == 0 {
            databaseSeg.selectedSegmentIndex = 0
        } else if DevelopmentSettingsController.devSettings.database == 1 {
            databaseSeg.selectedSegmentIndex = 1
        }
    }
    
    //MARK: Buttons Tapped
    @IBAction func adSwitchTapped(_ sender: Any) {
        DevelopmentSettingsController.devSettings.ads.toggle()
        NSLog("Ads are on: \(DevelopmentSettingsController.devSettings.ads)")
    }
    
    @IBAction func databaseSegTapped(_ sender: Any) {
        switch databaseSeg.selectedSegmentIndex {
        case 0:
            DevelopmentSettingsController.devSettings.database = 0
            print(databaseSeg.selectedSegmentIndex)
        case 1:
            DevelopmentSettingsController.devSettings.database = 1
            print(databaseSeg.selectedSegmentIndex)
        default:
            break
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        DevelopmentSettingsController.saveDevData()
        navigationController?.popViewController(animated: true)
    }
}


//MARK: Development Settings
struct DevelopmentSettings: Codable {
    var ads: Bool
    var database: Int
}


class DevelopmentSettingsController {
    static var devSettings = DevelopmentSettings(ads: true, database: 0)
    
    static func loadDevData() {
        if let data = UserDefaults.standard.data(forKey: "LoadDevelopmentData") {
            if let decoded = try? JSONDecoder().decode(DevelopmentSettings.self, from: data) {
                DevelopmentSettingsController.devSettings = decoded
                NSLog("Dev Data Loaded")
            }
        }
    }
    
    static func saveDevData() {
        if let encoded = try? JSONEncoder().encode(DevelopmentSettingsController.devSettings) {
            UserDefaults.standard.set(encoded, forKey: "LoadDevelopmentData")
            NSLog("Dev Data Saved")
        }
    }
    
    static func setDatabase() {
        if devSettings.database == 0 {
            FireStoreReferenceManager.inDevelopment = false
        }
        
        if devSettings.database == 1 {
            FireStoreReferenceManager.inDevelopment = true
        }
    }
}
