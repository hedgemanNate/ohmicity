//
//  Band.swift
//  Ohmicity Backend
//
//  Created by Nathan Hedgeman on 6/4/21.
//

import Foundation
import FirebaseFirestore

enum Genre: String, Codable {
    
    case Rock = "Rock/Alternative"
    case Blues
    case Jazz = "Jazz/Latin"
    case Dance
    case Reggae = "Reggae/Caribbean"
    case Country = "Country/Bluegrass"
    case FunkSoul = "Funk/Soul"
    case EDM
    case HipHop = "HipHop/Rap"
    case DJ
    case Pop
    case Metal = "Metal/Punk"
    case Experimental
    case JamBand
    case Gospel = "Gospel/Praise"
    case EasyListening
}

class Band: Codable, Equatable {
    static func == (lhs: Band, rhs: Band) -> Bool {
        return lhs.bandID == rhs.bandID || lhs.name == rhs.name
    }
    
    var bandID: String = UUID().uuidString
    var lastModified: Timestamp?
    var name: String
    var photo: Data?
    var genre: [Genre] = []
    
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
}
