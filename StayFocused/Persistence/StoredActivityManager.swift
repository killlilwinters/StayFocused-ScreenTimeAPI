//
//  StoredActivityManager.swift
//  StayFocused
//
//  Created by Maksym Horobets on 08.09.2025.
//

import SwiftData
import Foundation

// Nonisolated because it is also used in the extension
nonisolated final class StoredActivityManager {
    enum StoreError: Error {
        case notFound
    }
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.modelContext = ModelContext(modelContainer)
    }
    
    func createActivity(_ activity: StoredActivity) throws {
        modelContext.insert(activity)
        try save()
    }
    
    func setActivityIsActive(for activity: StoredActivity, isActive: Bool) throws {
        let activity = try fetchActivities(for: activity.activityID)
        activity.isActive = isActive
        try save()
    }
    
    func fetchActiveActivities() throws -> [StoredActivity] {
        let predicate = #Predicate<StoredActivity> { $0.isActive }
        let descriptor = FetchDescriptor<StoredActivity>(predicate: predicate)
        
        return try modelContext.fetch(descriptor)
    }
    
    func fetchActivities() throws -> [StoredActivity] {
        try modelContext.fetch(.init())
    }
    
    func fetchActivities(for identifier: UUID) throws -> StoredActivity {
        let predicate = #Predicate<StoredActivity> { $0.activityID == identifier }
        let descriptor = FetchDescriptor<StoredActivity>(predicate: predicate)
        
        guard let activity = try modelContext.fetch(descriptor).first else { throw StoreError.notFound }
        
        return activity
    }
    
    func removeActivity(_ activity: StoredActivity) throws {
        modelContext.delete(activity)
    }
    
    func eraseAllData() throws {
        try modelContext.delete(model: StoredActivity.self)
        try save()
    }
    
    private func save() throws {
        try modelContext.save()
    }
}
