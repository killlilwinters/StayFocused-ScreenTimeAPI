//
//  ContentViewModel.swift
//  StayFocused
//
//  Created by Maks Winters on 01.05.2025.
//

import os.log
import SwiftUI
import SwiftData
import DeviceActivity

private let cwmLogger = Logger(subsystem: "ContentView", category: "View")

@MainActor
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
    let storedActivityManager: StoredActivityManager
    let liveActivityManager: LiveActivityManager
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
    
    // Navigation
    var isActivityListPresented: Bool
    
    // Final deadline value
    var deadline: Date
    
    init(authManager: ScreenTimeAuthenticatable, modelContainer: ModelContainer) {
        
        // Managers
        self.storedActivityManager   = StoredActivityManager(modelContainer: modelContainer)
        self.liveActivityManager     = LiveActivityManager()
        self.activityRegistration    = ActivityRegistration(authManager: authManager, storedActivityManager: storedActivityManager)
        self.immediateShield         = ImmediateShield()
        
        // Choosing apps
        self.appListStorage          = try! AppListStorage()
        self.isFamilyPickerPresented = false
        
        // Running
        self.isRunning               = false
        self.isAnimatingBackground   = true
        
        // Picker selection
        self.pickerStyle             = .defaultPicker
        
        // Navigation
        self.isActivityListPresented = false
        
        // Final deadline value
        self.deadline                = .now
        
    }
    
    func dismissLiveActivityIfNeeded() {
        if !isRunning {
            finishLiveActivity()
        }
    }
    
    func restoreLastSessionTimer() async {
        guard let date = try? await activityRegistration.restoreLastSessionTimer() else { return }
        deadline = date
        isRunning = true
        isAnimatingBackground = !isRunning
    }
    
    func startFocus() {
        isRunning = true
        isAnimatingBackground = !isRunning
        
        immediateShield.shield()
        
        registerActivity()
        startLiveActivity()
    }
    
    func endFocus() {
        isRunning = false
        isAnimatingBackground = !isRunning
        
        unregisterActivity()
        finishLiveActivity()
    }
    
    private func registerActivity() {
        do {
            let activity = StoredActivity(
                name: "Temporary duration activity",
                activityID: UUID(),
                activityType: .duration(actualEndDate: deadline)
            )
            
            try storedActivityManager.createActivity(activity)
            try activityRegistration.register(activity)
            
            try storedActivityManager.setActivityIsActive(for: activity, isActive: true)
        } catch {
            print(error)
        }
    }
    
    private func unregisterActivity() {
        guard let runningActivity = try? storedActivityManager.fetchActiveActivities().first else { return }
        
        do {
            immediateShield.unshield()
            try storedActivityManager.removeActivity(runningActivity)
            try activityRegistration.remove(runningActivity)
        } catch {
            print(error)
        }
    }
    
    private func startLiveActivity() {
        liveActivityManager.startActivity(deadline: deadline)
    }
    
    private func finishLiveActivity() {
        liveActivityManager.finishActivity()
    }
    
}
