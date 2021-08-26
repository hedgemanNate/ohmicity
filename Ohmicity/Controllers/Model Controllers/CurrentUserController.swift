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
                        userAdController.setUpAdsForUser()
                    } else {
                        NSLog("User Data Not Found In Database")
                    }
                case .failure(let error):
                    NSLog(error.localizedDescription)
                }
            }
        }
    
    func pushCurrentUserData() {
        guard let uid = currentUserController.currentUser?.userID else {return NSLog("No Current User Found/Set")}
        do {
            try ref.userDataPath.document(uid).setData(from: currentUserController.currentUser)
        } catch {
            NSLog("Error pushing currentUser to database: signInButtonTapped")
        }
    }
    
    func pushCurrentUserData(_with uid: String) {
        do {
            try ref.userDataPath.document(uid).setData(from: currentUserController.currentUser)
        } catch {
            NSLog("Error pushing currentUser to database: signInButtonTapped")
        }
    }
}

let currentUserController = CurrentUserController()
