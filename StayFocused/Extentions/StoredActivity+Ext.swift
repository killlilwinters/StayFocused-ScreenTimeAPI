//
//  StoredActivity+Ext.swift
//  StayFocused
//
//  Created by Maksym Horobets on 09.09.2025.
//

import Foundation

extension StoredActivity {
    static var mockDuration: StoredActivity {
        StoredActivity(
            name: "Test activity",
            activityID: UUID(),
            activityType: .duration(
                actualEndDate: .now.addingTimeInterval(5 * 60)
            )
        )
    }
}
