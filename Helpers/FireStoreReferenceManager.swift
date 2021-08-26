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
    private static let environment = "remoteData"
    static let fireDataBase = Firestore.firestore()
    
    static let businessFullDataPath = fireDataBase.collection(environment).document(environment).collection("businessFullData")
    static let bandDataPath = fireDataBase.collection(environment).document(environment).collection("bandData")
    static let showDataPath = fireDataBase.collection(environment).document(environment).collection("showData")
    static let userDataPath = fireDataBase.collection(environment).document(environment).collection("userData")
    static let recommendationPath = fireDataBase.collection(environment).document(environment).collection("recommendationData")
//    static let businessBasicDataPath = fireDataBase.collection(environment).document(environment).collection("businesBasicData")
}

let ref = FireStoreReferenceManager.self
