//
//  TimeOfDay.swift
//  StayFocused
//
//  Created by Maksym Horobets on 08.09.2025.
//

import Foundation

// Original Problem Context: SwiftData does not properly handle DateComponents
// due to its internal structure (_CalendarProtocol), necessitating a custom, Codable alternative.
// https://fatbobman.com/en/posts/considerations-for-using-codable-and-enums-in-swiftdata-models/#:~:text=Such%20errors%20indicate,of%20the%20model.

/// Represents a specific time of day (e.g., 10:30 AM) in a date-agnostic way.
///
/// This struct is designed to be a lightweight, `Codable`, and `SwiftData`-compatible
/// alternative to `DateComponents`. It stores the time as a simple integer representing
/// the number of seconds that have passed since midnight (00:00:00) in UTC.
struct TimeOfDay: Equatable, Codable, Hashable {
    
    enum TimeError: LocalizedError {
        case invalidHourOrMinute
        case dateConversionFailed
        
        var errorDescription: String? {
            switch self {
            case .invalidHourOrMinute:
                // Assuming you have a Localizable.strings file for errors.
                String(localized: "timeofday_error_invalid_input_description", table: "ErrorLocalizable")
            case .dateConversionFailed:
                String(localized: "timeofday_error_conversion_failed_description", table: "ErrorLocalizable")
            }
        }
    }
    
    /// The number of seconds since midnight (00:00:00) in UTC. The canonical value.
    let utcSecondsSinceMidnight: Int
    
    /// Returns the hour and minute components derived from the UTC seconds.
    var dateComponents: DateComponents {
        let hour = utcSecondsSinceMidnight / 3600
        let minute = (utcSecondsSinceMidnight % 3600) / 60
        return DateComponents(hour: hour, minute: minute)
    }
    
    /// A `Date` object representing the stored time in the user's current calendar and timezone for today.
    /// For example, if the stored time is 08:30, this will be a `Date` for 8:30 AM today in the user's locale.
    var localizedDate: Date {
        // This correctly uses the current calendar to create a date from abstract components.
        // This is the intended logic: take the hour/minute and represent it in the user's timezone.
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    /// A localized string representation of the time, formatted for the user's locale (e.g., "8:30 AM" or "20:30").
    var description: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        // The formatter uses the user's current locale and timezone by default,
        // which is exactly what's needed here.
        return formatter.string(from: localizedDate)
    }
    
    /// Initializes the struct with a specific hour and minute.
    ///
    /// - Parameters:
    ///   - hour: The hour component (0-23).
    ///   - minute: The minute component (0-59).
    /// - Throws: `TimeError.invalidHourOrMinute` if the values are out of the valid range.
    init(hour: Int, minute: Int) throws {
        guard (0..<24).contains(hour), (0..<60).contains(minute) else {
            throw TimeError.invalidHourOrMinute
        }
        self.utcSecondsSinceMidnight = (hour * 3600) + (minute * 60)
    }
    
    /// Initializes the struct from a given `Date`, extracting the time components
    /// based on the user's current calendar and timezone.
    ///
    /// - Parameter date: The `Date` from which to extract the time.
    /// - Throws: `TimeError.dateConversionFailed` if the hour or minute cannot be extracted.
    init(from date: Date) throws {
        // This logic correctly captures the time as perceived by the user.
        // If the user's clock shows 10:45 PM, it extracts hour: 22 and minute: 45.
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        guard let hour = components.hour, let minute = components.minute else {
            throw TimeError.dateConversionFailed
        }
        try self.init(hour: hour, minute: minute)
    }
    
    /// Initializes the struct with a raw count of seconds since UTC midnight.
    ///
    /// - Parameter utcSecondsSinceMidnight: The number of seconds from 00:00:00 UTC.
    init(utcSecondsSinceMidnight: Int) {
        // Clamps the value to ensure it's within a valid 24-hour day.
        self.utcSecondsSinceMidnight = max(0, min(86399, utcSecondsSinceMidnight))
    }
}

// MARK: - Comparable Conformance
extension TimeOfDay: Comparable {
    static func < (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        // The original logic compared a complex calculation that resolved
        // to `secondsSinceMidnight`. This is a direct, clearer, and logically
        // identical comparison.
        lhs.utcSecondsSinceMidnight < rhs.utcSecondsSinceMidnight
    }
}
