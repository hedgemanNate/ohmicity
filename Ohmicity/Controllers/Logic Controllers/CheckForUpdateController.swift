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
            NotifyCenter.post(name: NSNotification.Name(rawValue: "VersionUpdateInfo")  , object: nil)
        }
    }
    
    static var forceUpdate = false {
        didSet {
            if forceUpdate == true {
                NotifyCenter.post(Notifications.forceUpdate)
            }
        }
    }
    
    
    static var installedVersion: Double {
        let v = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)
        return Double(v ?? "0.0") ?? 0.0
    }
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
    
    static func checkIfUpdateIsAvailable() async {
        await isUpdateAvailable { (update, error) in
            if let error = error {
                print(error)
            } else if let update = update {
                updateAvailable = update
            }
        }
        
    }
    
    static private func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) async {
        guard let info = Bundle.main.infoDictionary,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {return}
       
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw CheckingError.InvalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let storeVersion = result["version"] as? String else {
                    throw CheckingError.NoVersionFound
                }
                
                guard let storeVersion = Double(storeVersion) else { throw CheckingError.NoConversionPossible}
                let onDeviceVersion = installedVersion
                
                
                appStoreVersion = storeVersion
                forceUpdate = shouldForceUpdate()
                
                completion(storeVersion > onDeviceVersion, nil)
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
