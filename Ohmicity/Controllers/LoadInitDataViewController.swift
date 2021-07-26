//
//  LoadInitDataViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/14/21.
//

import UIKit
import Firebase

class LoadInitDataViewController: UIViewController {
    
    //Properties
    var todayShowArray: [Show] = []
    var todayVenueArray: [BusinessFullData] = []
    var todayDate = ""
    
    
    var dataActionsFinished = 0 {
        didSet {
            if dataActionsFinished == 3 {
                organizeData()
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
        
        //Organize Data
        notificationCenter.addObserver(self, selector: #selector(organizeData), name: notifications.organizeData.name, object: nil)
        
        lmDateHandler.checkDateAndGetData()
        dateFormatter.dateFormat = dateFormat3
        
        //resetCache
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = false
//        settings.isPersistenceEnabled = true
        
    }
    @IBAction func btn(_ sender: Any) {
        print("****Tapped****")
        //resetCache
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        settings.isPersistenceEnabled = true
    }
    
    @objc private func counting() {
        dataActionsFinished += 1
        print(dataActionsFinished)
    }
    
    //MARK: Adding shows to Today
    @objc private func organizeData() {
        getTodaysDate()
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        
        let op1 = BlockOperation {
            for show in showController.showArray {
                let stringDate = dateFormatter.string(from: show.date)
                
                if stringDate == self.todayDate {
                    showController.todayShowArray.append(show)
                }
            }
        }
        
        let op2 = BlockOperation {
            for show in showController.todayShowArray {
                for venue in businessController.businessArray {
                    if show.venue == venue.name {
                        businessController.todayVenueArray.append(venue)
                    }
                }
            }
        }
        
        let op3 = BlockOperation {
            self.doneLoading()
        }
        
        op2.addDependency(op1)
        op3.addDependency(op2)
        opQueue.addOperations([op1, op2, op3], waitUntilFinished: true)
        
    }
    
    private func getTodaysDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        //todayDate = dateFormatter.string(from: Date())
        todayDate = "July 17, 2021"
    }
    
    
    private func doneLoading() {
        //print(showController.showArray)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ToDashboard", sender: self)
        }
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
