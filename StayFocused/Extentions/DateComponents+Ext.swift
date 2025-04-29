//
//  DateComponents+Ext.swift
//  StayFocused
//
//  Created by Maks Winters on 29.04.2025.
//

import Foundation

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
