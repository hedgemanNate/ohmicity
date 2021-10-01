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
    case All
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

enum MenuType {
    case Rating
}

enum Genre: String, Codable {
    case Rock
    case Blues
    case Jazz
    case Dance
    case Reggae
    case Country
    case FunkSoul
    case EDM
    case HipHop
    case DJ
    case Pop
    case Metal
    case Experimental
    case JamBand
    case Gospel
    case EasyListening
}
