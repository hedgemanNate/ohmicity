//
//  ProductionBandController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/27/22.
//

import Foundation

class ProductionBandController {
    static var bandGroupArray = [GroupOfProductionBands]()
}


//MARK: Network Functions
extension ProductionBandController {
    static func getRawBandData() async throws {
        let snap = try await FireStoreReferenceManager.bandDataPath.getDocuments()
        
        ProductionBandController.bandGroupArray = snap.documents.compactMap({ bandGroup in
            try? bandGroup.data(as: GroupOfProductionBands.self)
        })
    }
}
