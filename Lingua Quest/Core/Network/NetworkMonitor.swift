//
//  NetworkMonitor.swift
//  Lingua Quest
//
//  Created by siam on 27/07/2026.
//

import Foundation
import Network
import Observation

@Observable
@MainActor
final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    var isConnected: Bool = true
    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        guard monitor == nil else { return }
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor?.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
    }
}
