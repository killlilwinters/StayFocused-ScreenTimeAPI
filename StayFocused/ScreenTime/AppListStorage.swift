//
//  AppListStorage.swift
//  DidYouDev
//
//  Created by Maks Winters on 27.04.2025.
//

import FamilyControls
import ManagedSettings
import Foundation

/// `AppListStorage` is responsible for saving user's `app` or `category` selection in a convenient way.
final class AppListStorage {
    private let identifier = "AppListStorage"
    private let userDefaults = UserDefaults(suiteName: SharedConstants.groupIdentifier)!
    
    /// Assigning to this prorepty calls internal methods to save assigned `FamilyActivitySelection`
    /// to the local storage.
    var activitySelection: FamilyActivitySelection {
        didSet {
            try? self.saveSelectionToDiscourage(activitySelection)
        }
    }
    
    /// Computed `get only` property to get a `Set` of `ApplicationToken` to discourage.
    var appSelectionToDiscourage: Set<ApplicationToken> {
        var applicationTokens: Set<ApplicationToken> = .init()
        for item in activitySelection.applicationTokens {
            applicationTokens.insert(item)
        }
        return applicationTokens
    }
    
    /// Computed `get only` property to get a `Set` of `ActivityCategoryToken` to discourage.
    var categorySelectionToDiscourage: Set<ActivityCategoryToken> {
        var categoryTokens: Set<ActivityCategoryToken> = .init()
        for item in activitySelection.categoryTokens {
            categoryTokens.insert(item)
        }
        return categoryTokens
    }
    
    /// Initializes the `AppListStorage` struct and tries to decode last saved data.
    init() throws {
        let data = userDefaults.data(forKey: identifier) ?? Data()
        let decoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        self.activitySelection = decoded ?? FamilyActivitySelection()
    }
    
    private func saveSelectionToDiscourage(_ selection: FamilyActivitySelection) throws {
        let data = try JSONEncoder().encode(selection)
        userDefaults.set(data, forKey: identifier)
    }
}
