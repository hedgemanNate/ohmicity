//
//  FireStoreReferenceManager.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/8/21.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class FireStoreReferenceManager {
    private static var environment = "remoteData"
    
    static let inDevelopment = true
    
    private static var switchData: String {
        var switchData = ""
        
        if inDevelopment == true {
            switchData = "workingData"
        }
        
        if inDevelopment == false {
            switchData = "productionData"
        }
        return switchData
    }
    
    
    
    static let fireDataBase = Firestore.firestore()
    
    static let userDataPath = fireDataBase.collection("productionData").document("productionData").collection("allUserData")
    
    static let bandDataPath = fireDataBase.collection(switchData).document(switchData).collection("allBandData")
    static let showDataPath = fireDataBase.collection(switchData).document(switchData).collection("allShowData")
    static let venueDataPath = fireDataBase.collection(switchData).document(switchData).collection("allVenueData")
    static let bannerDataPath = fireDataBase.collection(switchData).document(switchData).collection("allBannerData")
    
    static let recommendationPath = fireDataBase.collection(switchData).document(switchData).collection("recommendationData")
    static let xitySupportDataPath = fireDataBase.collection(switchData).document(switchData).collection("xitySupportData")
}
