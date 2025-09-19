//
//  ImmediateShield.swift
//  StayFocused
//
//  Created by Maks Winters on 29.04.2025.
//

import Foundation
import FamilyControls
import ManagedSettings

struct ImmediateShield {
    private let store = ManagedSettingsStore()
    
    /// This computed property returns a `Bool`, representing if there is any shielding active at the moment.
    var isShielded: Bool {
        store.shield.applications != nil || store.shield.applicationCategories != nil
    }
    
    /// Immediately shelds apps from `AppListStorage`.
    func shield(with model: AppListStorage) {
        let applications = model.appSelectionToDiscourage
        let categories = model.categorySelectionToDiscourage
        
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = categories.isEmpty ? nil : .specific(categories)
    }
    
    func shield(with selection: FamilyActivitySelection) {
        let applications = selection.applicationTokens
        let categories = selection.categoryTokens
        
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = categories.isEmpty ? nil : .specific(categories)
    }
    
    /// Immediately unshields all the shielded apps.
    func unshield() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }
    
}
