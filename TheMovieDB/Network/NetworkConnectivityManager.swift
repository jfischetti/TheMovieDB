//
//  NetworkConnectivityManager.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/16/21.
//

import Foundation
import Network
import RxSwift

class NetworkConnectivityManager {

    let monitor = NWPathMonitor()
    private var isMonitoring = false
    private var status: NWPath.Status = .requiresConnection
    let isReachable: BehaviorSubject<Bool>

    init() {
        isReachable = BehaviorSubject<Bool>(value: true)
    }

    func startMonitoring() {
        if isMonitoring == false {
            isMonitoring = true

            //reset status
            status = .requiresConnection

            monitor.pathUpdateHandler = { [weak self] path in
                print("Connection status changed from \(self!.status) to \(path.status)")
                if let status = self?.status, status != path.status {
                    DispatchQueue.main.async {
                        print("Sending status change!")
                        self?.isReachable.onNext(path.status == .satisfied)
                    }
                }

                self?.status = path.status
            }

            let queue = DispatchQueue(label: "NetworkMonitor")
            monitor.start(queue: queue)
        }
    }

    func stopMonitoring() {
        isMonitoring = false
        monitor.cancel()
    }
}
