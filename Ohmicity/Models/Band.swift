//
//  Band.swift
//  Ohmicity Backend
//
//  Created by Nathan Hedgeman on 6/4/21.
//

import Foundation
import FirebaseFirestore



class Band: Codable, Equatable, Hashable {
    static func == (lhs: Band, rhs: Band) -> Bool {
        return lhs.bandID == rhs.bandID || lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    var bandID: String = UUID().uuidString
    var lastModified: Timestamp?
    var name: String
    var photo: Data?
    var genre: [Genre] = []
    var ratings: [BandsRatings]?
    var mediaLink: String?
    var ohmPick: Bool = false
    
    init(name: String) {
        self.name = name
    }
    
    init(newBand: Band) {
        bandID = newBand.bandID
        name = newBand.name
        photo = newBand.photo
        genre = newBand.genre
        mediaLink = newBand.mediaLink
        ohmPick = newBand.ohmPick
    }
    
    init(singleBand: SingleProductionBand) {
        bandID = singleBand.bandID
        name = singleBand.name
        photo = singleBand.photo
        genre = singleBand.genre
        mediaLink = singleBand.mediaLink
        
        if singleBand.genre == [] {
            genre.append(Genre.NA)
        }
    }

}
