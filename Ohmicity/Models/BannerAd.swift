//
//  BannerAd.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/27/21.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift


//MARK: MAKE CODABLE - Remove UIImage property
class BannerAd: Equatable {
    static func == (lhs: BannerAd, rhs: BannerAd) -> Bool {
        lhs.bannerAdID == rhs.bannerAdID
    }
    
    //Properties
    let bannerAdID: String
    var imageData: Data?
    var image: UIImage?
    let businessID: String
    var lastModified: Timestamp?
    
    
    init(_with data: Data, businessID: String) {
        self.bannerAdID = UUID().uuidString
        self.imageData = data
        self.businessID = businessID
    }
    
    init(_with image: UIImage, businessID: String) {
        self.bannerAdID = UUID().uuidString
        self.image = image
        self.businessID = businessID
    }
}
