//
//  Enumerations.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/9/21.
//

import Foundation

enum DataResults {
    case success
    case failure
}

enum City: String, Codable, Hashable {
    case Sarasota
    case Bradenton
    case Venice
    case StPete
    case Tampa
    case Ybor
}

enum LoadingScreenInfo: String {
    case BannerAdsLoaded
    case BannerAdsCollected
    case ShowsLoaded
    case ShowsCollected
    case BusinessesLoaded
    case BusinessesCollected
    case BandsLoaded
    case BandsCollected
}
