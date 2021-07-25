//
//  Enumerations.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/9/21.
//

import Foundation

enum DataResults {
    case success
    case failure
}

enum City: String, Codable {
    case Sarasota
    case Bradenton
    case Venice
    case StPete
    case Tampa
    case Ybor
}
