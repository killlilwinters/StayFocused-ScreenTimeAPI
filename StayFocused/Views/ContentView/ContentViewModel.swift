//
//  ContentViewModel.swift
//  StayFocused
//
//  Created by Maks Winters on 01.05.2025.
//

import SwiftUI
import os.log

private let cwmLogger = Logger(subsystem: "ContentView", category: "View")

@Observable
final class ContentViewModel {
    enum PickerStyle: CaseIterable {
        case defaultPicker, datePicker
        
        var description: String {
            switch self {
            case .defaultPicker: "Default Picker"
            case .datePicker:    "Date Picker"
            }
        }
    }
    
    // Managers
    let activityRegistration: ActivityRegistration
    let immediateShield: ImmediateShield
    
    // Choosing apps
    var appListStorage: AppListStorage
    var isFamilyPickerPresented: Bool
    
    // Running
    var isRunning: Bool
    var isAnimatingBackground: Bool
    
    // Picker selection
    var pickerStyle: PickerStyle
    
    // Final deadline value
    var deadline: Date
    
    init(authManager: ScreenTimeAuthenticatable) {
        
        // Managers
        self.activityRegistration    = ActivityRegistration(authManager: authManager)
        self.immediateShield         = ImmediateShield()
        
        // Choosing apps
        self.appListStorage          = try! AppListStorage()
        self.isFamilyPickerPresented = false
        
        // Running
        self.isRunning               = false
        self.isAnimatingBackground   = true
        
        // Picker selection
        self.pickerStyle             = .defaultPicker
        
        // Final deadline value
        self.deadline                = .now
        
    }
    
    func restoreLastSessionTimer() async {
        do {
            guard let date = try await activityRegistration.restoreLastSessionTimer() else { return }
            deadline = date
            isRunning = true
            isAnimatingBackground = !isRunning
        } catch {
            cwmLogger.log("Dropped restoring due to: \(error.localizedDescription)")
        }
    }
    
    func handleStateChange() {
        isAnimatingBackground = !isRunning
        
        isRunning ? immediateShield.shield() : immediateShield.unshield()
        isRunning ? registerActivity() : unregisterActivity()
    }
    
    func toggleRunning() {
        withAnimation {
            isRunning.toggle()
            isAnimatingBackground = !isRunning
        }
    }
    
    func registerActivity() {
        let activity = RegisterActivity(
            timerActivityIdentifier,
            start: DateComponents.now,
            end: DateComponents.init(from: deadline),
            repeats: false
        )
        
        try? activityRegistration.register(activity)
    }
    
    func unregisterActivity() {
        try? activityRegistration.remove(timerActivityIdentifier)
    }
    
}
