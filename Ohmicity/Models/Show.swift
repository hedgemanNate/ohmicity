//
//  Show.swift
//  Ohmicity Backend
//
//  Created by Nathan Hedgeman on 6/4/21.
//
import Foundation
import FirebaseFirestore

struct Show: Codable, Equatable, Hashable {
    var showID: String
    var lastModified = Timestamp()
    let band: String
    let venue: String
    var bandDisplayName: String
    var city: [City] = []
    var dateString: String?
    var date: Date
    var time = ""
    var onHold: Bool = false //To removed shows from user cache
    var ohmPick: Bool = false
    
    //Equatable Conformity
    static func == (lhs: Show, rhs: Show) -> Bool {
        return lhs.venue == rhs.venue && lhs.date == rhs.date
    }

    //Hashable Conformity
    func hash(into hasher: inout Hasher) {
        hasher.combine(venue)
        hasher.combine(band)
        hasher.combine(date)
    }
    
    
}
 
extension Show {
    
    init(band: String, venue: String, date: Date, displayName: String) {
        
        let showID = Firestore.firestore().collection("showData").document().documentID
        self.showID = showID
        self.band = band
        self.venue = venue
        self.bandDisplayName = displayName
        self.date = date
    }
    
    init(singleShow: SingleProductionShow) {
        self.showID = singleShow.showID
        self.band = singleShow.band
        self.venue = singleShow.venue
        self.bandDisplayName = singleShow.bandDisplayName
        self.date = singleShow.date
    }
}
