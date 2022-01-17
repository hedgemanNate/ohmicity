//
//  Favorite.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/16/22.
//

import Foundation

struct Favorite: Hashable {
    let favoriteID: String
    var bandFavorite: Band?
    var venueFavorite: Business?
}
