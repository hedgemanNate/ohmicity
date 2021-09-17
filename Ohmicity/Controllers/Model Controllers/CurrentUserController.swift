//
//  CurrentUserController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/5/21.
//

import Firebase

class CurrentUserController {
    
    var currentUser: CurrentUser? {
        didSet {
            notificationCenter.post(notifications.userAuthUpdated)
            print("***!!!!CURRENT USER SET!!!")
        }
    }
    
    var preferredCity: City? {
        didSet {
            currentUser?.preferredCity = preferredCity
            xityShowController.todayShowArrayFilter = preferredCity
            //Can be more financially efficient
            currentUserController.pushCurrentUserData()
            
        }
        
    }
    
    var favArray = [Business]()
    
    
    //MARK: Functions
    func assignCurrentUser() {
            guard let id = Auth.auth().currentUser?.uid else { return NSLog("No Current User ID: assignCurrentUser") }
            
            ref.userDataPath.document(id).getDocument { document, error in
                let result = Result {
                    try document?.data(as: CurrentUser.self)
                }
                switch result {
                case.success(let user):
                    if let user = user {
                        self.currentUser = user
                        self.setUpCurrentUserPreferences()
                    } else {
                        NSLog("User Data Not Found In Database")
                    }
                case .failure(let error):
                    NSLog(error.localizedDescription)
                }
            }
        }
    
    func getUserXitySupportLast24Hours() {
        if currentUser == nil { NSLog("No User"); return }
        
        let userSupportQuery = ref.xitySupportDataPath
            .whereField("userID", isEqualTo: currentUser!.userID)
            .whereField("time", isGreaterThan: timeController.aDayAgo)
        
        userSupportQuery.getDocuments { querySnapShot, err in
            if let err = err {
                NSLog(err.localizedDescription)
            } else {
                for document in querySnapShot!.documents {
                    let result = Result {
                        try document.data(as: XitySupport.self)
                    }
                    switch result {
                    case .success(let support):
                        if let support = support {
                            xitySupportController.xitySupportInstances.append(support)
                        }
                    case .failure(let error):
                        NSLog(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func setUpCurrentUserPreferences() {
        //Ad Experience Setup
        userAdController.setUpAdsForUser()
        
        //Preferred City Setup
        if currentUser?.preferredCity == nil {
            return
        } else {
            xityShowController.todayShowArrayFilter = currentUser?.preferredCity
        }
    }
    
    func pushCurrentUserData() {
        
        guard let uid = currentUserController.currentUser?.userID else {return NSLog("No Current User Found/Set")}
        do {
            try ref.userDataPath.document(uid).setData(from: currentUserController.currentUser)
        } catch let error {
            NSLog(error.localizedDescription)
        }
    }
    
    func pushCurrentUserData(_with uid: String) {
        do {
            try ref.userDataPath.document(uid).setData(from: currentUserController.currentUser)
        } catch let error {
            NSLog(error.localizedDescription)
        }
    }
}

let currentUserController = CurrentUserController()
