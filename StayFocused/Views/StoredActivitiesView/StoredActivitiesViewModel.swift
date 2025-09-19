//
//  StoredActivitiesViewModel.swift
//  StayFocused
//
//  Created by Maksym Horobets on 09.09.2025.
//

import SwiftUI

@MainActor
@Observable
final class StoredActivitiesViewModel {
    
    var error: Error? = nil
    var isErrorPresented: Binding<Bool> {
        Binding(
            get: { self.error != nil },
            set: { if !$0 { self.error = nil } }
        )
    }
    
    var activities: Array<StoredActivity> = .init()
    var updatesTask: Task<Void, Never>?
    
    private let storedActivityManager: StoredActivityManager
    private let registrationCenter: ActivityRegistrationCenter
    
    init(
        storedActivityManager: StoredActivityManager,
        registrationCenter: ActivityRegistrationCenter
    ) {
        self.storedActivityManager = storedActivityManager
        self.registrationCenter = registrationCenter
        
        self.updatesTask = Task.detached { [weak self] in
            for await _ in NotificationCenter.default.notifications(named: .NSPersistentStoreRemoteChange) {
                await self?.fetchActivities()
            }
        }
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
            self.error = error
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
            self.error = error
        }
    }
    
    func deleteActivity(_ activity: StoredActivity) {
        do {
            try? registrationCenter.remove(activity) // Try to remove if registered
            try storedActivityManager.removeActivity(activity)
            fetchActivities()
        } catch {
            self.error = error
        }
    }
    
}
