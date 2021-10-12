//
//  Enumerations.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/9/21.
//

import Foundation

//MARK: Data
enum DataResults {
    case success
    case failure
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

//MARK: Venue
enum City: String, Codable, Hashable {
    case Sarasota
    case Bradenton
    case Venice
    case StPete
    case Tampa
    case Ybor
    case All
}

enum BusinessType: String, Codable, Equatable, Hashable {
    case Restaurant
    case Bar
    case Club
    case Outdoors
    case LiveMusic = "Live Music"
    case Family = "Family Friendly"
    case None
}

//MARK: Band
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
    case NA
}


//MARK: User
enum SubscriptionType: String, Codable, Equatable {
    case err
    case None
    case FrontRowPass = "Front Row Pass"
    case BackStagePass = "Backstage Pass"
    case FullAccessPass = "Full Access Pass"
}

enum Features: String, Codable {
    case Favorites
    case NoPopupAds
    case SeeAllData
    case XityDeals
    case ShowReminders
    case TodayShowFilter
    case Search
}

//MARK: Need Fixing
enum MenuType: String {
    case Rating
}
