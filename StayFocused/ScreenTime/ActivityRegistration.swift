//
//  ActivityRegistration.swift
//  StayFocused
//
//  Created by Maks Winters on 29.04.2025.
//

import DeviceActivity
import ManagedSettings
import Foundation

/// A `class` used for registering activities to the `DeviceActivity` framework.
final class ActivityRegistration: ActivityRegistrationProtocol {
    enum Error: LocalizedError {
        case notFound
        case expired
        case missingDate
        
        var errorDescription: String? {
            switch self {
            case .notFound:    "Previous activity has expired"
            case .expired:     "Authorization expired"
            case .missingDate: "Dropped restoring due to missing date"
            }
        }
    }
    
    private let center = DeviceActivityCenter()
    private let authManager: ScreenTimeAuthenticatable
    
    /// Initializer.
    /// - Parameter authManager: A Screen Time authentication class, conforming to `ScreenTimeAuthenticatable`.
    init(authManager: ScreenTimeAuthenticatable) {
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
    
    func getActivity(for name: String) throws -> RegisterActivity {
        try authManager.checkAuthorization
        
        let activityName = DeviceActivityName(name)
        guard let activitySchedule = center.schedule(for: activityName) else { throw Self.Error.notFound }
        
        let rActivity = RegisterActivity(
            activityName.rawValue,
            start: activitySchedule.intervalStart,
            end: activitySchedule.intervalEnd,
            repeats: activitySchedule.repeats
        )
        
        return rActivity
    }
    
    func restoreLastSessionTimer() async throws -> Date? {
        // Async buys us some time to wait for an Authentication to take place
        let activity = try getActivity(for: timerActivityIdentifier)
        
        guard activity.schedule.intervalEnd > DateComponents.now else {
            throw ActivityRegistration.Error.expired
        }
        
        guard let date = activity.schedule.intervalEnd.fullDate else {
            throw ActivityRegistration.Error.missingDate
        }
        
        return date
    }
    
}
