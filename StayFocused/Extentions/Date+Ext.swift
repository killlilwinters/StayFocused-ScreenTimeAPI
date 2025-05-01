//
//  Date+Ext.swift
//  StayFocused
//
//  Created by Maks Winters on 28.04.2025.
//

import Foundation

extension Date {
    /// Returns a current date with the specified time added to it.
    /// - Parameters:
    ///   - hour: An `Int` representation of how many hours to add.
    ///   - minute: An `Int` representation of how many minutes to add.
    /// - Returns: Returs `Date` with added time.
    static func appendingToCurrentDate(hour: Int, minute: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        return Calendar.current.date(byAdding: dateComponents, to: Date()) ?? Date()
    }
}
