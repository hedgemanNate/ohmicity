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
    
    var preferredCity: City = .All {
        didSet {
            currentUser?.preferredCity = preferredCity
            xityShowController.todayShowArrayFilter = preferredCity
            //Can be more financially efficient
        }
        
    }
    
    var favArray = [Business]()
    
    
    //MARK: Functions
    func assignCurrentUser() {
            guard let id = Auth.auth().currentUser?.uid else { return NSLog("No Current User ID: assignCurrentUser") }
            
            ref.userDataPath.document(id).getDocument { [self] document, error in
                let result = Result {
                    try document?.data(as: CurrentUser.self)
                }
                switch result {
                case.success(let user):
                    if let user = user {
                        //MARK: BETA
                        checkForNilProperties(currentUser: user)
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
        xityShowController.todayShowArrayFilter = currentUser?.preferredCity ?? .All
    }
    
    func pushCurrentUserData() {
        
        guard let uid = currentUser?.userID else {return NSLog("No Current User Found/Set")}
        do {
            currentUser?.lastModified = Timestamp()
            try ref.userDataPath.document(uid).setData(from: currentUser)
            print("pushCurrentUserData")
        } catch let error {
            NSLog(error.localizedDescription)
            print("pushCurrentUserData Error")
        }
    }
    
    func pushCurrentUserData(_with uid: String) {
        do {
            try ref.userDataPath.document(uid).setData(from: currentUser)
        } catch let error {
            NSLog(error.localizedDescription)
        }
    }
    
    private func checkForNilProperties(currentUser: CurrentUser) {
        if currentUser.bandRatings == nil {
            currentUser.bandRatings = []
        }
        
        if currentUser.features == nil {
            currentUser.features = []
        }
        
        if currentUser.preferredCity == nil {
            currentUser.preferredCity = .All
        }
        
        if currentUser.recommendationCount == nil {
            currentUser.recommendationCount = 0
        }
        
        if currentUser.recommendationBlackOutDate == nil {
            currentUser.recommendationBlackOutDate = Date()
        }
        
        if currentUser.supportBlackOutDate == nil {
            currentUser.supportBlackOutDate = Date()
        }
    }
}

let currentUserController = CurrentUserController()
