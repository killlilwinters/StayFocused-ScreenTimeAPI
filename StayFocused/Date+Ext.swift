//
//  Date+Ext.swift
//  StayFocused
//
//  Created by Maks Winters on 28.04.2025.
//

import Foundation

extension Date {
    static func appendingToCurrentDate(hour: Int, minute: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        return Calendar.current.date(byAdding: dateComponents, to: Date()) ?? Date()
    }
}
