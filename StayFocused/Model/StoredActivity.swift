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
        
        var iconSystemName: String {
            switch self {
            case .duration: "timer"
            case .scheduled: "hourglass"
            }
        }
        
        var description: String {
            switch self {
            case .duration(let actualEndDate):
                let formattedEndDate = actualEndDate.formatted(.dateTime.hour().minute())
                return "Duration block ending at \(formattedEndDate)"
            case .scheduled(let startTime, let endTime, _):
                return "Scheduled block. Start: \(startTime.description) End: \(endTime.description)"
            }
        }
    }
    
    var name: String
    var activityID: UUID
    var activityType: ActivityType
    
    var isActive: Bool
    
    init(
        name: String,
        activityID: UUID,
        activityType: ActivityType
    ) {
        self.name = name
        self.activityID = activityID
        self.activityType = activityType
        self.isActive = false
    }
}
