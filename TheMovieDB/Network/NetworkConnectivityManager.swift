//
//  NetworkConnectivityManager.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/16/21.
//

import Foundation
import Network

class NetworkConnectivityManager {

    static let shared = NetworkConnectivityManager()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
