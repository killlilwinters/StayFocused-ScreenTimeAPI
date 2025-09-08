//
//  ActivityRegistrationProtocol.swift
//  StayFocused
//
//  Created by Maks Winters on 01.05.2025.
//

import Foundation

/// Defines the interface for registering, removing, and querying device activities.
protocol ActivityRegistrationProtocol {
    
    /// Registers an activity into the DeviceActivityCenter.
    /// - Parameter activity: A `StoredActivity` instance to start monitoring.
    /// - Throws: Any error thrown during authorization or scheduling.
    func register(_ activity: StoredActivity) throws
    
    /// Removes the specified activity from monitoring.
    /// - Parameter activity: A `StoredActivity` instance to stop monitoring.
    /// - Throws: Any error thrown during authorization.
    func remove(_ activity: StoredActivity) throws
    
    /// Stops monitoring all activities.
    func stopMonitoring()
    
    /// Returns the end date of the last timer session if it’s still valid.
    /// - Throws: `ActivityRegistration.Error.expired` if the session has passed,
    ///           `ActivityRegistration.Error.missingDate` if the end date is unavailable.
    func restoreLastSessionTimer() async throws -> Date?
}
