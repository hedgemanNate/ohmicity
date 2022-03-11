//
//  PurchaseController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 10/5/21.
//

import Foundation


class PurchaseController {
    
//    static let shared = PurchaseController()
//    var permission: Qonversion.Permission?
//    
//    private init() {}
//    
//    func configure(completion: @escaping (Bool) -> Void) {
//        guard let currentUser = currentUserController.currentUser else {return}
//        Qonversion.setUserID(currentUser.userID)
//        Qonversion.launch(withKey: "UL89NAez-wRFJ3pVBEAxg0mCrUDShLlw") { result, err in
//            if let err = err {
//                NSLog("💰 \(err.localizedDescription)")
//                completion(false)
//                return
//            }
//            
//            print("ID: \(result)")
//            completion(true)
//            
//        }
//    }
//    
//    func checkPermissions() {
//        Qonversion.checkPermissions { permissions, err in
//            print("Qonversion Permissions: \(permissions)")
//            let type: [SubscriptionType] = [.FrontRowPass, .BackStagePass, .FullAccessPass]
//            
//            
//            
//            if permissions.contains(where: {$0.value.isActive == true}) {
//                let perm = permissions.first(where: {$0.value.isActive == true})
//                guard let key = perm?.key else {NSLog("🚇 Permission with no key. Call Qonversion for help"); return}
//                guard let subscription = type.first(where: {$0.rawValue == key}) else { print("checkPermissions function fail"); return}
//                print("🚨 Permission found")
//                userAdController.userSubscription = subscription
//            } else {
//                print("🚨 No permission found")
//            }
//        }
//    }
//    
//    func purchase(pass: SubscriptionType, completion: @escaping (Bool) -> Void) {
//        Qonversion.purchase(pass.rawValue) { result, err, cancelled in
//            if let err = err {
//                NSLog("💰 \(err.localizedDescription)")
//                completion(false)
//                return
//            }
//            
//            if cancelled {
//                completion(false)
//            } else {
//                userAdController.userSubscription = pass
//                completion(true)
//            }
//        }
//    }
//    
//    func restorePurchases(completion: @escaping (Bool) -> Void) {
//        Qonversion.restore { result, err in
//            if let err = err {
//                NSLog("💰 \(err.localizedDescription)")
//                completion(false)
//                return
//            }
//            
//            if result.isEmpty {
//                completion(false)
//            } else {
//                let type: [SubscriptionType] = [.FrontRowPass, .BackStagePass, .FullAccessPass]
//                guard let key = result.first?.key else {return}
//                guard let subscription = type.first(where: {$0.rawValue == key}) else {return}
//                userAdController.userSubscription = subscription
//                completion(true)
//            }
//        }
//    }
    
}
