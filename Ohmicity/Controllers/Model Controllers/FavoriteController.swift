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
        
        for band in currentUser.favoriteBands {
            let foundBand = bandController.bandArray.first(where: {$0.bandID == band})
            guard let foundBand = foundBand else {continue}
            let newFav = Favorite(favoriteID: foundBand.bandID, bandFavorite: foundBand, venueFavorite: nil)
            favoritesArray.append(newFav)
        }
        
        for venue in currentUser.favoriteBusinesses {
            let foundVenue = businessController.businessArray.first(where: {$0.venueID == venue})
            guard let foundVenue = foundVenue else {continue}
            let newFav = Favorite(favoriteID: foundVenue.venueID, bandFavorite: nil, venueFavorite: foundVenue)
            favoritesArray.append(newFav)
        }
    }
    
    static func createFavorite(objectID: String) {
        if currentUserController.currentUser == nil {return}
        if bandController.bandArray.contains(where: {$0.bandID == objectID}) {
            let foundBand = bandController.bandArray.first(where: {$0.bandID == objectID})
            let newFav = Favorite(favoriteID: foundBand!.bandID, bandFavorite: foundBand, venueFavorite: nil)
            favoritesArray.append(newFav)
            
        
        } else {
            if businessController.businessArray.contains(where: {$0.venueID == objectID}) {
                let foundVenue = businessController.businessArray.first(where: {$0.venueID == objectID})
                let newFav = Favorite(favoriteID: foundVenue!.venueID, bandFavorite: nil, venueFavorite: foundVenue)
                favoritesArray.append(newFav)
                
            }
        }
        
    }
}
