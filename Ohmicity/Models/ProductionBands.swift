//
//  ProductionBands.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/20/22.
//

import Foundation


class AllProductionBands {
    static var allBands = [GroupOfProductionBands]()
}

struct GroupOfProductionBands: Codable {
    var groupOfProductionBandsID : String?
    var bands: [SingleProductionBand]
}

struct SingleProductionBand: Codable{
    let bandID: String
    let name: String
    let photo: Data?
    let genre: [Genre]
    var mediaLink: String?
    let ohmPick: Bool
    let special: Bool
    
    init(bandID: String, name: String, photo: Data?, genre: [Genre], mediaLink: String?, ohmPick: Bool) {
        
        self.bandID = bandID
        self.name = name
        self.photo = photo
        self.genre = genre
        self.mediaLink = mediaLink
        self.ohmPick = ohmPick
        self.special = false
    }
}
