//
//  DeviceActivityMonitorExtension.swift
//  TimerMonitor
//
//  Created by Maks Winters on 29.04.2025.
//

import DeviceActivity
import ManagedSettings

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    private let center = DeviceActivityCenter()
    private let store = ManagedSettingsStore()

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        
        center.stopMonitoring([activity])
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
}
