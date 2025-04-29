//
//  ActivityRegistration.swift
//  StayFocused
//
//  Created by Maks Winters on 29.04.2025.
//

import DeviceActivity
import ManagedSettings
import Foundation

final class ActivityRegistration {
    
    private let center = DeviceActivityCenter()
    private let authManager: ScreenTimeAuth
    
    init(authManager: ScreenTimeAuth) {
        self.authManager = authManager
    }
    
    func register(_ activity: RegisterActivity) throws {
        try authManager.checkAuthorization
        guard !center.activities.contains(activity.name) else { return }
        
        try center.startMonitoring(activity.name, during: activity.schedule)
        print("Initiate monitoring for \(activity.name)")
    }
    
    func remove(_ activity: RegisterActivity) throws {
        try authManager.checkAuthorization
        center.stopMonitoring([activity.name])
    }
    
    func remove(_ name: String) throws {
        try authManager.checkAuthorization
        center.stopMonitoring([DeviceActivityName(rawValue: name)])
    }
    
    func stopMonitoring() {
        center.stopMonitoring()
    }
    
}

struct RegisterActivity {
    
    let name: DeviceActivityName
    let schedule: DeviceActivitySchedule

    #warning("Activities, created less than 15 minutes into the future get omited by the system.")
    init(_ identifier: String, start: DateComponents, end: DateComponents, repeats: Bool) {
        self.name = DeviceActivityName(rawValue: identifier)
        self.schedule = DeviceActivitySchedule(
            intervalStart: start,
            intervalEnd: end,
            repeats: repeats
        )
    }
    
}
