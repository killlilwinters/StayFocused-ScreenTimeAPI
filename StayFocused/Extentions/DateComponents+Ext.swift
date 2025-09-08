//
//  DateComponents+Ext.swift
//  StayFocused
//
//  Created by Maks Winters on 29.04.2025.
//
// https://stackoverflow.com/a/64516065
//

import Foundation

// MARK: - Initialized
extension DateComponents {
  /// Convert these components into a Date using a real Calendar.
  var fullDate: Date? {
    return Calendar.current.date(from: self)
  }
}

// MARK: - Static
extension DateComponents {
    
    static let startOfDay = DateComponents(hour: 0, minute: 0, second: 0)
    static let endOfDay = DateComponents(hour: 23, minute: 59, second: 59)
    
    static var now: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
    }
    
    init(from date: Date) {
        self = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    }
    
}

// MARK: - Instance
extension DateComponents {
    /// Returns new `DateComponents` by adding the specified number of seconds
    /// to the current hour, minute, and second. Wraps around at 24 hours.
    ///
    /// - Parameter seconds: The number of seconds to add (can be negative).
    /// - Returns: A new `DateComponents` instance with the updated time.
    ///
    /// Example:
    /// ```swift
    /// let components = DateComponents(hour: 23, minute: 59, second: 50)
    /// let updated = components.adding(seconds: 15)
    /// // updated.hour == 0, updated.minute == 0, updated.second == 5
    /// ```
    func adding(seconds: Int) -> DateComponents {
        let hour = self.hour ?? 0
        let minute = self.minute ?? 0
        let second = self.second ?? 0

        
        let totalSeconds = hour * 3600 + minute * 60 + second + seconds
        let newHour = ((totalSeconds / 3600) % 24 + 24) % 24
        let newMinute = ((totalSeconds % 3600) / 60 + 60) % 60
        let newSecond = ((totalSeconds % 60) + 60) % 60
        
        return DateComponents(hour: newHour, minute: newMinute, second: newSecond)
    }
}

// MARK: - Conformances
extension DateComponents: @retroactive Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: lhs, to: now)! < calendar.date(byAdding: rhs, to: now)!
    }
}
