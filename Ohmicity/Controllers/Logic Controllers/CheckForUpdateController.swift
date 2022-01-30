//
//  CheckForUpdateController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/29/22.
//

import Foundation

class CheckForUpdateController {
    
    enum CheckingError: Error {
        case BadIdentifier
        case InvalidResponse
        case NoVersionFound
        case NoConversionPossible
    }
    
    //Properties
    static var updateAvailable = false {
        didSet {
            print("📱 There is a newer version: \(updateAvailable)")

        }
    }
    
    static var forceUpdate = false {
        didSet {
            if forceUpdate == true {
                NotifyCenter.post(Notifications.forceUpdate)
            }
        }
    }
    
    static var installedVersion: Double = 0
    static var appStoreVersion: Double = 0
    
    
    //MARK: Functions
    
    static func shouldForceUpdate() -> Bool {
        print("App Store Version: \(appStoreVersion) Installed Version: \(installedVersion)")
        print("Version Gap: \(appStoreVersion - installedVersion)")
        if appStoreVersion - installedVersion > 0.05 {
            return true
        } else {
            return false
        }
    }
    
    static func checkIfUpdateIsAvailable() {
        isUpdateAvailable { (update, error) in
            if let error = error {
                print(error)
            } else if let update = update {
                updateAvailable = update
            }
        }
        
    }
    
    static private func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {return}
       
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw CheckingError.InvalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw CheckingError.NoVersionFound
                }
                
                guard let version = Double(version) else { throw CheckingError.NoConversionPossible}
                guard let currentVersion = Double(currentVersion) else {throw CheckingError.NoConversionPossible}
                
                installedVersion = currentVersion
                appStoreVersion = version
                forceUpdate = shouldForceUpdate()
                
                completion(version >= currentVersion, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
/*
@discardableResult let _ = try? isUpdateAvailable { (update, error) in
            if let error = error {
                print(error)
            } else if let update = update {
                print("There is a new Version: \(update)")
            }
        }
 */
