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
let dateFormat1 = "E, MMMM d, yyyy ha"
let dateFormat2 = "MMMM d, yyyy ha"
let dateFormat3 = "MMMM d, yyyy"


//Needed When Data Is Unavailable or Missing to keep from crashing or wonkiness
let blankBand = Band(name: "No Show")
let blankShow = Show(showID: "", band: "No Show", venue: "No Show", dateString: "No Show Scheduled", time: "No Time")
let blankBusiness = Business(name: "No Location", address: "No Location", phoneNumber: 0, website: "No Location")
let blankXityShow = XityShow(band: blankBand, business: blankBusiness, show: blankShow)


