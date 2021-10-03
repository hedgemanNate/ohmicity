//
//  Subscriptions.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/9/21.
//

import Foundation
import UIKit

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
