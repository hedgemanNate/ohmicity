//
//  FavoriteController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/16/22.
//

import Foundation

enum FavoriteError: Error {
    case objectNotBand
    case objectNotVenue
}

class FavoriteController {
    static var favoritesArray = [Favorite]() {
        didSet {
            let set = Set(favoritesArray)
            favoritesArray = Array(set)
            favoritesArray.sort(by: {$0.type < $1.type})
            notificationCenter.post(notifications.userFavoritesUpdated)
        }
    }
}

//MARK: Functions
extension FavoriteController {
    static func generateFavorites() {
        guard let currentUser = currentUserController.currentUser else {
            NSLog("❗️Can't generate favorites: No user is logged in.")
            return
        }
        
        for fav in currentUser.favoriteBusinesses {
            let newFavorite = Favorite(favoriteID: fav)
            guard let newFavorite = newFavorite else {continue}
            FavoriteController.favoritesArray.append(newFavorite)
        }
        
        for fav in currentUser.favoriteBands {
            let newFavorite = Favorite(favoriteID: fav)
            guard let newFavorite = newFavorite else {continue}
            FavoriteController.favoritesArray.append(newFavorite)
        }
        
    }
    
    static func createFavorite(objectID: String) {
        if currentUserController.currentUser == nil {return}
        if BandController.bandArray.contains(where: {$0.bandID == objectID}) {
            let foundBand = BandController.bandArray.first(where: {$0.bandID == objectID})
            guard let foundBand = foundBand else {return}
            let newFav = Favorite(bandFavorite: foundBand)
            favoritesArray.append(newFav)
            
        } else {
            if BusinessController.businessArray.contains(where: {$0.venueID == objectID}) {
                let foundVenue = BusinessController.businessArray.first(where: {$0.venueID == objectID})
                guard let foundVenue = foundVenue else {return}
                let newFav = Favorite(venueFavorite: foundVenue)
                favoritesArray.append(newFav)
            }
        }
        
    }
}
