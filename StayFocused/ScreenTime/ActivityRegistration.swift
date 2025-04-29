//
//  ActivityRegistration.swift
//  StayFocused
//
//  Created by Maks Winters on 29.04.2025.
//

import DeviceActivity
import ManagedSettings
import Foundation

/// A **class** used for registering activities to the **DeviceActivity** framework.
final class ActivityRegistration {
    
    private let center = DeviceActivityCenter()
    private let authManager: ScreenTimeAuth
    
    /// Initializer.
    /// - Parameter authManager: A Screen Time authentication class, conforming to **ScreenTimeAuthenticatable**.
    init(authManager: ScreenTimeAuth) {
        self.authManager = authManager
    }
    
    
    /// Registers an activity into the **DeviceActivityCenter**.
    /// - Parameter activity: **RegisterActivity** instance.
    func register(_ activity: RegisterActivity) throws {
        try authManager.checkAuthorization
        guard !center.activities.contains(activity.name) else { return }
        
        try center.startMonitoring(activity.name, during: activity.schedule)
        print("Initiate monitoring for \(activity.name)")
    }
    
    /// Removes the activity from monitoring in the **DeviceActivityCenter**.
    /// - Parameter activity: **RegisterActivity** instance.
    func remove(_ activity: RegisterActivity) throws {
        try authManager.checkAuthorization
        center.stopMonitoring([activity.name])
    }
    
    /// Removes the activity from monitoring in the **DeviceActivityCenter**.
    /// - Parameter name: A **String** representing a **DeviceActivityName**.
    func remove(_ name: String) throws {
        try authManager.checkAuthorization
        center.stopMonitoring([DeviceActivityName(rawValue: name)])
    }
    
    /// Removes all activities from monitoring in the **DeviceActivityCenter**.
    func stopMonitoring() {
        center.stopMonitoring()
    }
    
}
