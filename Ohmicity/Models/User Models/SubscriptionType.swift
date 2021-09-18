//
//  Subscriptions.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/9/21.
//

import Foundation
import UIKit

enum SubscriptionType: String, Codable, Equatable {
    case None
    case FrontRowPass = "Front Row Pass"
    case BackStagePass = "Back Stage Pass"
    case FullAccessPass = "Full Access Pass"
}

enum Features: String, Codable {
    case Favorites
    case NoPopupAds
    
}

struct Subscription {
    var type: SubscriptionType
    var description: String
    var features: [PaywallFeature] = []
    var price: String
}

struct PaywallFeature {
    let image: UIImage
    let name: String
}
