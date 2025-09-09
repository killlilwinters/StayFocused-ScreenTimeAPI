//
//  StoredActivitiesViewModel.swift
//  StayFocused
//
//  Created by Maksym Horobets on 09.09.2025.
//

import Foundation

@MainActor
@Observable
final class StoredActivitiesViewModel {
    
    var activities: Array<StoredActivity> = .init()
    
    let storedActivityManager: StoredActivityManager
    
    init(storedActivityManager: StoredActivityManager) {
        self.storedActivityManager = storedActivityManager
    }
    
    func fetchActivities() {
        do {
            activities = try storedActivityManager.fetchActivities()
        } catch {
            print(error)
        }
    }
    
}
