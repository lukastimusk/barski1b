//
//  NetworkManager.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-04-21.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import Combine
import Network

class NetworkManager: ObservableObject {
    @Published var isConnectedToWiFi: Bool = false
    
    func checkWiFiConnection() {
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    if let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String {
                        // Check if SSID is available, indicating connection to WiFi
                        isConnectedToWiFi = !ssid.isEmpty
                        return
                    }
                }
            }
        }
        // If no SSID found, not connected to WiFi
        isConnectedToWiFi = false
    }
}


class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    @Published var isActive = false
    @Published var isExpensive = false
    @Published var isConstrained = false
    @Published var connectionType = NWInterface.InterfaceType.other
    
    init() {
        monitor.pathUpdateHandler = {path in
            DispatchQueue.main.async {
                self.isActive = path.status == .satisfied
                self.isExpensive = path.isExpensive
                self.isConstrained = path.isConstrained
                
                let connectionTypes: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet, .other]
                
                self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other
            }
        }
        monitor.start(queue: queue)
    }
    
}
