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

// MARK: - Conformances
extension DateComponents: @retroactive Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: lhs, to: now)! < calendar.date(byAdding: rhs, to: now)!
    }
}
