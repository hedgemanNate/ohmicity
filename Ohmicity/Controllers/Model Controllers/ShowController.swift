//
//  ShowController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/9/21.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

class ShowController {
    //Properties
    
    var todayShowArray = [Show]()
    var showArray: [Show] = [] {
        didSet {
            
        }
    }
    
    let db = Firestore.firestore()
                      .collection("remoteData")
                      .document("remoteData")
                      .collection("showData")
    
    
    //Functions
    func removeHolds() {
        showArray.removeAll(where: {$0.onHold == true})
    }
    
    func getAllShowData() {
        FireStoreReferenceManager.showDataPath.document(ProductionShowController.allShows.allProductionShowsID).getDocument { snapShot, error in
            let result = Result {
                try snapShot?.data(as: AllProductionShows.self)
            }
            switch result {
            case .success(let success):
                if let allShows = success {
                    ProductionShowController.allShows = allShows
                    self.fillShowArrayFromRawShowData()
                } else {
                    NSLog("Production Shows were not found: getAllShowData")
                }
            case .failure(let failure):
                NSLog(failure.localizedDescription)
            }
        }
        notificationCenter.post(notifications.gotAllShowData)
    }
    
    func fillShowArrayFromRawShowData() {
        for show in ProductionShowController.allShows.shows {
            if !bandController.bandArray.contains(where: {$0.bandID == show.band}) {print("No band"); continue}
            if !businessController.businessArray.contains(where: {$0.venueID == show.venue}) {print("No Venue"); continue}
            
            let venue = businessController.businessArray.first(where: {$0.venueID == show.venue})
            guard let venue = venue else {continue}
            
            let cleanDisplay = show.bandDisplayName.capitalized

            timeController.dateFormatter.dateFormat = timeController.monthDayYear
            var newShow = Show(showID: show.showID, band: show.band, venue: show.venue, bandDisplayName: cleanDisplay, dateString: timeController.dateFormatter.string(from: show.date), date: show.date)
            
            newShow.ohmPick = show.ohmPick
            newShow.city = venue.city
            newShow.city.append(.All)
            
            showArray.append(newShow)
        }
        notificationCenter.post(notifications.gotCacheShowData)
    }
}

let showController = ShowController()
