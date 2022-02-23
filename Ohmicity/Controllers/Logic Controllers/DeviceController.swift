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
            heightConstraint = 801
        case .iPhone6sPlus:
            heightConstraint = 801
        case .iPhone7:
            heightConstraint = 801
        case .iPhone7Plus:
            heightConstraint = 801
        case .iPhoneSE:
            heightConstraint = 785
        case .iPhone8:
            heightConstraint = 801
        case .iPhone8Plus:
            heightConstraint = 801
        case .iPhoneX:
            heightConstraint = 801
        case .iPhoneXS:
            heightConstraint = 801
        case .iPhoneXSMax:
            heightConstraint = 801
        case .iPhoneXR:
            heightConstraint = 801
        case .iPhone11:
            heightConstraint = 801
        case .iPhone11Pro:
            heightConstraint = 801
        case .iPhone11ProMax:
            heightConstraint = 801
        case .iPhoneSE2:
            heightConstraint = 801
        case .iPhone12:
            heightConstraint = 801
        case .iPhone12Mini:
            heightConstraint = 801
        case .iPhone12Pro:
            heightConstraint = 801
        case .iPhone12ProMax:
            heightConstraint = 801
        case .iPhone13:
            heightConstraint = 801
        case .iPhone13Mini:
            heightConstraint = 801
        case .iPhone13Pro:
            heightConstraint = 801
        case .iPhone13ProMax:
            heightConstraint = 801

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
            heightConstraint = 801
        case .iPhone7:
            heightConstraint = 801
        case .iPhone7Plus:
            heightConstraint = 801
        case .iPhoneSE:
            heightConstraint = 785
        case .iPhone8:
            heightConstraint = 801
        case .iPhone8Plus:
            heightConstraint = 801
        case .iPhoneX:
            heightConstraint = 801
        case .iPhoneXS:
            heightConstraint = 801
        case .iPhoneXSMax:
            heightConstraint = 801
        case .iPhoneXR:
            heightConstraint = 801
        case .iPhone11:
            heightConstraint = 801
        case .iPhone11Pro:
            heightConstraint = 801
        case .iPhone11ProMax:
            heightConstraint = 801
        case .iPhoneSE2:
            heightConstraint = 801
        case .iPhone12:
            heightConstraint = 801
        case .iPhone12Mini:
            heightConstraint = 801
        case .iPhone12Pro:
            heightConstraint = 801
        case .iPhone12ProMax:
            heightConstraint = 801
        case .iPhone13:
            heightConstraint = 801
        case .iPhone13Mini:
            heightConstraint = 801
        case .iPhone13Pro:
            heightConstraint = 801
        case .iPhone13ProMax:
            heightConstraint = 801
        default:
            heightConstraint = 801
        }
    }
}
