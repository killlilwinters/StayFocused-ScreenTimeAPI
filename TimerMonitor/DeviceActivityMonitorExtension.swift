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
    let helper = ActivityMonitorHelper()
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        // Self is not sendable so let's make a local copy of the helper.
        let helper = self.helper
        Task {
            await helper.intervalDidStart(for: activity)
        }
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
}
