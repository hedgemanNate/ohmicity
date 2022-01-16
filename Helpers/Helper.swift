//
//  Handlers.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 5/14/21.
//

import Foundation
import Firebase

var authHandle: AuthStateDidChangeListenerHandle?

let dateFormatter = DateFormatter()
let dateFormatter2 = DateFormatter()

//Needed When Data Is Unavailable or Missing to keep from crashing or wonkiness
let blankBand = Band(name: "No Show")
let blankShow = Show(band: "No Band", venue: "No Venue", date: Date(), dateString: "No Date", displayName: "No Display Name")
let blankBusiness = Business(name: "No Location", address: "No Location", phoneNumber: 0, website: "No Location")
let blankXityShow = XityShow(band: blankBand, business: blankBusiness, show: blankShow)



