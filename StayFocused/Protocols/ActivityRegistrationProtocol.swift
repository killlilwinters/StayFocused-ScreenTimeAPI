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
    /// - Parameter activity: A `RegisterActivity` instance to start monitoring.
    /// - Throws: Any error thrown during authorization or scheduling.
    func register(_ activity: RegisterActivity) throws
    
    /// Removes the specified activity from monitoring.
    /// - Parameter activity: A `RegisterActivity` instance to stop monitoring.
    /// - Throws: Any error thrown during authorization.
    func remove(_ activity: RegisterActivity) throws
    
    /// Removes the activity with the given name from monitoring.
    /// - Parameter name: A `String` representing the raw value of a `DeviceActivityName`.
    /// - Throws: Any error thrown during authorization.
    func remove(_ name: String) throws
    
    /// Stops monitoring all activities.
    func stopMonitoring()
    
    /// Retrieves a previously registered activity.
    /// - Parameter name: A `String` representing the raw value of the `DeviceActivityName` to look up.
    /// - Returns: A `RegisterActivity` instance containing the activity’s name, interval start/end, and repetition flag.
    /// - Throws: `ActivityRegistration.Error.notFound` if no matching activity is being monitored.
    func getActivity(for name: String) throws -> RegisterActivity
    
    /// Returns the end date of the last timer session if it’s still valid.
    /// - Throws: `ActivityRegistration.Error.expired` if the session has passed,
    ///           `ActivityRegistration.Error.missingDate` if the end date is unavailable,
    ///           or any error from `getActivity(for:)`.
    func restoreLastSessionTimer() async throws -> Date?
}
