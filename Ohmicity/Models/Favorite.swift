//
//  Favorite.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/16/22.
//

enum FavoriteType: Comparable {
    case band
    case venue
}

import Foundation

struct Favorite: Hashable {
    let favoriteID: String
    var bandFavorite: Band?
    var venueFavorite: Business?
    let type: FavoriteType
    
    init(bandFavorite: Band) {
        self.favoriteID = bandFavorite.bandID
        self.bandFavorite = bandFavorite
        self.venueFavorite = nil
        self.type = .band
    }
    
    init(venueFavorite: Business) {
        self.favoriteID = venueFavorite.venueID
        self.venueFavorite = venueFavorite
        self.bandFavorite = nil
        self.type = .venue
    }
    
    init?(favoriteID: String) {
        
        var band: Band?
        var venue: Business?
        var type: FavoriteType?
        
        if let foundBand = bandController.bandArray.first(where: {$0.bandID == favoriteID}) {
            band = foundBand
            venue = nil
            type = .band
        } else if let foundVenue = businessController.businessArray.first(where: {$0.venueID == favoriteID}) {
            venue = foundVenue
            band = nil
            type = .venue
        }
        
        guard let type = type else {return nil}
        
        self.favoriteID = favoriteID
        self.bandFavorite = band
        self.venueFavorite = venue
        self.type = type
    }
}

