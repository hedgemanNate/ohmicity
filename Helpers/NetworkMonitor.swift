//
//  NetworkMonitor.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/23/21.
//

import Foundation
import Network


class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            self.status = path.status
            self.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                NSLog("We're connected!")
                notificationCenter.post(notifications.hasConnection)
            } else {
                NSLog("No connection.")
                notificationCenter.post(notifications.lostConnection)
            }
        }

        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

let networkMonitor = NetworkMonitor()
