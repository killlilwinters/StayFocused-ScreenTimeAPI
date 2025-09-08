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
@MainActor
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
    private let storedActivityManager: StoredActivityManager
    
    /// Initializer.
    /// - Parameter authManager: A Screen Time authentication class, conforming to `ScreenTimeAuthenticatable`.
    init(
        authManager: ScreenTimeAuthenticatable,
        storedActivityManager: StoredActivityManager
    ) {
        self.authManager = authManager
        self.storedActivityManager = storedActivityManager
    }
    
    
    func register(_ activity: StoredActivity) throws {
        try authManager.checkAuthorization
        
        let deviceActivityName = DeviceActivityName(activity.activityID.uuidString)
        if center.activities.contains(deviceActivityName) {
            center.stopMonitoring([deviceActivityName])
        }
        
        let schedule: DeviceActivitySchedule
        switch activity.activityType {
        case .duration(let actualEndDate):
            
            // MARK: Workaround
            // Use start as the end for duration for the ability to schedule duration unblocking for less than 15 minutes.
            let endAsComponents = DateComponents.init(from: actualEndDate)
            let workaroundEndTime = endAsComponents.adding(seconds: 15 * 60)
            
            schedule = DeviceActivitySchedule(intervalStart: endAsComponents, intervalEnd: workaroundEndTime, repeats: false)
        case .scheduled(let startTime, let endTime, let contentToBlock):
            #warning("Coming soon...")
            schedule = DeviceActivitySchedule(intervalStart: .init(), intervalEnd: .init(), repeats: false)
        }
        
        try center.startMonitoring(deviceActivityName, during: schedule)
        print("Initiate monitoring for \(deviceActivityName)")
    }
    
    func remove(_ activity: StoredActivity) throws {
        try authManager.checkAuthorization
        let name = DeviceActivityName(activity.activityID.uuidString)
        center.stopMonitoring([name])
    }
    
    func stopMonitoring() {
        center.stopMonitoring()
    }
    
    func restoreLastSessionTimer() async throws -> Date? {
        // Async buys us some time to wait for an Authentication to take place
        guard let activity = try storedActivityManager.fetchActiveActivities().first else { return nil }
        
        let endDate: Date?
        switch activity.activityType {
        case .duration(let actualEndDate):
            endDate = actualEndDate
        case .scheduled(_, let endTime, _):
            let components = endTime.dateComponents
            endDate = Calendar.current.date(
                bySettingHour: components.hour ?? 0,
                minute: components.minute ?? 0,
                second: components.second ?? 0,
                of: Date()
            )
        }
        
        return endDate
    }
    
}
