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

struct Subscription {
    var type: SubscriptionType
    var description: String
    var features: [Feature] = []
    var price: String
}

struct Feature {
    let image: UIImage
    let name: String
}
