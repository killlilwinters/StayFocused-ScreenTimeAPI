//
//  ImmediateShield.swift
//  StayFocused
//
//  Created by Maks Winters on 29.04.2025.
//

import Foundation
import ManagedSettings

struct ImmediateShield {
    private let store = ManagedSettingsStore()
    
    /// This computed property returns a **Bool**, representing if there is any shielding active at the moment.
    var isShielded: Bool {
        store.shield.applications != nil || store.shield.applicationCategories != nil
    }
    
    /// Immediately shelds apps from **AppListStorage**.
    func shield() {
        let model = try? AppListStorage()
        guard let model else { return }
        
        let applications = model.appSelectionToDiscourage
        let categories = model.categorySelectionToDiscourage
        
        store.shield.applications = applications.isEmpty ? nil : applications
        
        store.shield.applicationCategories = categories.isEmpty ? nil : .specific(categories)
    }
    
    /// Immediately unshields all the shielded apps.
    func unshield() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }
    
    /// Toggles between sheild and unshield based on the current state.
    func toggle() {
        isShielded ? unshield() : shield()
    }
    
}
