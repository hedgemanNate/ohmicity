//
//  DeviceController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 2/23/22.
//

import Foundation
import UIKit
import DeviceKit

class DeviceController {
    static var heightConstraint: CGFloat = 800
    
    
    static func getDeviceAndSetHeightConstraint() {
        
        let device = Device.current
        NSLog("📱 Device is a: \(device)‼️")
        
        switch device {
        case .iPhone6s:
            heightConstraint = 890
        case .iPhone6sPlus:
            heightConstraint = 962
        case .iPhone7:
            heightConstraint = 890
        case .iPhone7Plus:
            heightConstraint = 962
        case .iPhoneSE:
            heightConstraint = 785
        case .iPhone8:
            heightConstraint = 890
        case .iPhone8Plus:
            heightConstraint = 962
        case .iPhoneX:
            heightConstraint = 976
        case .iPhoneXS:
            heightConstraint = 976
        case .iPhoneXSMax:
            heightConstraint = 1064
        case .iPhoneXR:
            heightConstraint = 1060
        case .iPhone11:
            heightConstraint = 1060
        case .iPhone11Pro:
            heightConstraint = 976
        case .iPhone11ProMax:
            heightConstraint = 1064
        case .iPhoneSE2:
            heightConstraint = 890
        case .iPhone12:
            heightConstraint = 1007
        case .iPhone12Mini:
            heightConstraint = 971
        case .iPhone12Pro:
            heightConstraint = 1007
        case .iPhone12ProMax:
            heightConstraint = 1092
        case .iPhone13:
            heightConstraint = 1007
        case .iPhone13Mini:
            heightConstraint = 971
        case .iPhone13Pro:
            heightConstraint = 1007
        case .iPhone13ProMax:
            heightConstraint = 1092

        case .simulator(let device):
            getDeviceAndSet(device)
        default:
            heightConstraint = 801
        }
    }
    
    private static func getDeviceAndSet(_ device: Device) {
        switch device {
        case .iPhone6s:
            heightConstraint = 890
        case .iPhone6sPlus:
            heightConstraint = 962
        case .iPhone7:
            heightConstraint = 890
        case .iPhone7Plus:
            heightConstraint = 962
        case .iPhoneSE:
            heightConstraint = 785
        case .iPhone8:
            heightConstraint = 890
        case .iPhone8Plus:
            heightConstraint = 962
        case .iPhoneX:
            heightConstraint = 976
        case .iPhoneXS:
            heightConstraint = 976
        case .iPhoneXSMax:
            heightConstraint = 1064
        case .iPhoneXR:
            heightConstraint = 1060
        case .iPhone11:
            heightConstraint = 1060
        case .iPhone11Pro:
            heightConstraint = 976
        case .iPhone11ProMax:
            heightConstraint = 1064
        case .iPhoneSE2:
            heightConstraint = 890
        case .iPhone12:
            heightConstraint = 1007
        case .iPhone12Mini:
            heightConstraint = 971
        case .iPhone12Pro:
            heightConstraint = 1007
        case .iPhone12ProMax:
            heightConstraint = 1092
        case .iPhone13:
            heightConstraint = 1007
        case .iPhone13Mini:
            heightConstraint = 971
        case .iPhone13Pro:
            heightConstraint = 1007
        case .iPhone13ProMax:
            heightConstraint = 1092
        default:
            heightConstraint = 801
        }
    }
}
