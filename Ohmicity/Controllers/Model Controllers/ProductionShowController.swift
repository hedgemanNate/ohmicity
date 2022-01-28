//
//  ProductionShowController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/16/22.
//

import Foundation

//MARK: Properties
class ProductionShowController {
    static var allShows = AllProductionShows(shows: [SingleProductionShow]())
}


//MARK: Network Functions
extension ProductionShowController {
    static func getRawShowData() async throws {
        let snap = try await FireStoreReferenceManager.showDataPath.document("EB7BD27C-15EA-43A5-866A-BF6883D0DD67").getDocument()
        
        ProductionShowController.allShows = try snap.data(as: AllProductionShows.self)!
    }
}
