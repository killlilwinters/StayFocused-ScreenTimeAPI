//
//  StoredActivity.swift
//  StayFocused
//
//  Created by Maksym Horobets on 08.09.2025.
//

import SwiftData
import Foundation
import FamilyControls

@Model
final class StoredActivity {
    enum ActivityType: Codable {
        case duration(actualEndDate: Date)
        case scheduled(startTime: TimeOfDay, endTime: TimeOfDay, contentToBlock: FamilyActivitySelection)
    }
    
    var activityID: UUID
    var activityType: ActivityType
    
    var isActive: Bool
    
    init(
        activityID: UUID,
        activityType: ActivityType
    ) {
        self.activityID = activityID
        self.activityType = activityType
        self.isActive = false
    }
}
