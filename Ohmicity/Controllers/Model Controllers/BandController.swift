//
//  BandController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/9/21.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

class BandController {
    //Properties
    
    static var bandArray: [Band] = [] { didSet { /*function here*/  }}
    static let genreTypeArray: [Genre] = [.Blues, .Country, .DJ, .Dance, .EDM, .EasyListening, .Experimental, .FunkSoul, .Gospel, .HipHop, .JamBand, .Jazz, .Metal, .Pop, .Reggae, .Rock, .SynthPop, .RnB, .Latin, .Folk, .Soul, .Americana, .ClassicRock, .World, .Alternative, .BlueGrass]
}
