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
    
    private let storedActivityManager: StoredActivityManager
    private let registrationCenter: ActivityRegistrationCenter
    
    init(
        storedActivityManager: StoredActivityManager,
        registrationCenter: ActivityRegistrationCenter
    ) {
        self.storedActivityManager = storedActivityManager
        self.registrationCenter = registrationCenter
    }
    
    func isScheduled(for storedActivity: StoredActivity) -> Bool {
        registrationCenter.isRegistered(storedActivity)
    }
    
    func setIsScheduled(for storedActivity: StoredActivity, isScheduled: Bool) {
        do {
            if isScheduled {
                try registrationCenter.register(storedActivity)
            } else {
                try registrationCenter.remove(storedActivity)
            }
        } catch {
            print(error)
        }
    }
    
    func fetchActivities() {
        do {
            // Cannot sort an enum with associated values using SortDescriptor in SwiftData.FetchDescriptor
            activities = try storedActivityManager
                .fetchActivities()
                .sorted(
                    using: SortDescriptor(\.activityType, order: .reverse)
                )
        } catch {
            print(error)
        }
    }
    
}
