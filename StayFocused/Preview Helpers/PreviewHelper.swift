//
//  PreviewHelper.swift
//  StayFocused
//
//  Created by Maksym Horobets on 08.09.2025.
//

import SwiftData
import Foundation

enum PreviewHelper {
    static let inMemoryContainer: ModelContainer = {
        let schema = Schema([StoredActivity.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: config)
        
        return container
    }()
}
