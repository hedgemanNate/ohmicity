//
//  Venue.swift
//  Ohmicity Backend
//
//  Created by Nate Hedgeman on 6/2/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol MutatingProtocolForBusinessData {
    //Empty for the purpose adding Hours to a business
}

class Business: Codable, Equatable, Hashable {
    static func == (lhs: Business, rhs: Business) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(phoneNumber)
    }
    
    let venueID: String
    var lastModified: Timestamp?
    var name: String
    var address: String = ""
    var city: [City] = []
    var phoneNumber: Int = 0
    var hours: Hours = Hours(mon: "", tues: "", wed: "", thur: "", fri: "", sat: "", sun: "")
    var logo: Data = Data()
    var pics: [Data] = []
    var stars: Int = 0
    var customer: Bool = false
    var ohmPick: Bool = false
    var website: String?
    var businessType: [BusinessType] = []
    
    init(name: String, address: String, phoneNumber: Int, website: String) {
        
        let venueID = ""
        self.venueID = venueID
        self.name = name
        self.address = address
        self.phoneNumber = phoneNumber
        self.website = website
    }
}


struct Hours: Codable, Equatable, Hashable {
    var monday: String = " "
    var tuesday: String = " "
    var wednesday: String = " "
    var thursday: String = " "
    var friday: String = " "
    var saturday: String = " "
    var sunday: String = " "
    
    init(mon: String, tues: String, wed: String, thur: String, fri: String, sat: String, sun: String) {
        self.monday = mon
        self.tuesday = tues
        self.wednesday = wed
        self.thursday = thur
        self.friday = fri
        self.saturday = sat
        self.sunday = sun
    }
    
    private init?(dictionary: [String : Any]) {
        guard let mon = dictionary["monday"] as? String,
              let tues = dictionary["tuesday"] as? String,
              let wed = dictionary["wednesday"] as? String,
              let thur = dictionary["thursday"] as? String,
              let fri = dictionary["friday"] as? String,
              let sat = dictionary["saturday"] as? String,
              let sun = dictionary["sunday"] as? String else {return nil}
        
        self.monday = mon
        self.tuesday = tues
        self.wednesday = wed
        self.thursday = thur
        self.friday = fri
        self.saturday = sat
        self.sunday = sun
    }
}
