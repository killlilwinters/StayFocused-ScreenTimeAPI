//
//  ScheduleCreationViewModel.swift
//  StayFocused
//
//  Created by Maksym Horobets on 10.09.2025.
//

import Foundation
import FamilyControls

@MainActor
@Observable
final class ScheduleCreationViewModel {
    // Settings
    var name: String = "New activity"
    var startTime: Date = .now.addingTimeInterval(5 * 60)
    var endTime: Date = .now.addingTimeInterval(20 * 60)
    
    var activitySelection: FamilyActivitySelection = .init()
    var isActivitySelectionPresented: Bool = false
    
    func constructActivity() throws -> StoredActivity {
        let startTime = try TimeOfDay(from: startTime)
        let endTime = try TimeOfDay(from: endTime)
        
        return StoredActivity(
            name: name,
            activityID: .init(),
            activityType: .scheduled(
                startTime: startTime,
                endTime: endTime,
                contentToBlock: activitySelection
            )
        )
    }
}
