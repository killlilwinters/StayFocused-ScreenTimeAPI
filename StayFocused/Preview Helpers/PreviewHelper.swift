//
//  PreviewHelper.swift
//  StayFocused
//
//  Created by Maksym Horobets on 08.09.2025.
//

import SwiftData
import Foundation

@MainActor
enum PreviewHelper {
    static let inMemoryContainer: ModelContainer = {
        let schema = Schema([StoredActivity.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: config)
        
        return container
    }()
    
    static let mockStoredActivityManager: StoredActivityManager = {
        StoredActivityManager(modelContainer: inMemoryContainer)
    }()
    
    static let mockActivityRegistrationCenter: ActivityRegistrationCenter = {
        ActivityRegistrationCenter(authManager: ScreenTimeAuth(), storedActivityManager: mockStoredActivityManager)
    }()
}
