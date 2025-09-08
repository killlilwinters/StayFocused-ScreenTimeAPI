//
//  ActivityMonitorHelper.swift
//  TimerMonitor
//
//  Created by Maksym Horobets on 08.09.2025.
//

import SwiftData
import Foundation
import DeviceActivity
import ManagedSettings

// Marking it nonisolated to make sure nobody wants to add @MainActor here.
nonisolated struct ActivityMonitorHelper {
    private let container: ModelContainer = {
        let schema = Schema([StoredActivity.self])
        let config = ModelConfiguration(groupContainer: .identifier(SharedConstants.groupIdentifier))
        
        // If you want to debug this extension - prints won't do, create a logger and log every needed step.
        return try! ModelContainer(for: schema, configurations: config)
    }()
    
    private let store = ManagedSettingsStore()
    
    func intervalDidStart(for activity: DeviceActivityName) async {
        guard let uuid = UUID(uuidString: activity.rawValue) else { return }
        let storedActivityManager = StoredActivityManager(modelContainer: container)
        
        guard let storedActivity = try? storedActivityManager.fetchActivities(for: uuid) else { return }
        
        switch storedActivity.activityType {
        case .duration(let actualEndDate):
            try? storedActivityManager.setActivityIsActive(for: storedActivity, isActive: false)
            
            let offsetSeconds = Int(actualEndDate.timeIntervalSinceNow)
            
            await offset(seconds: offsetSeconds)
            
            store.shield.applications = nil
            store.shield.applicationCategories = nil
            
            DeviceActivityCenter().stopMonitoring([activity])
        case .scheduled(let startTime, let endTime, let contentToBlock):
            #warning("Coming soon...")
        }
    }
    
    func intervalDidEnd(for activity: DeviceActivityName) {
        #warning("Coming soon...")
    }
    
    private func offset(seconds: Int) async {
        var counter = 0
        while counter < seconds {
            // I decided not to do Task.sleep(for: .seconds(seconds))) so that the system sees activity
            // in the extension and does not kill it.
            // Basically this solution is safer.
            try? await Task.sleep(for: .seconds(1), tolerance: .milliseconds(100))
            counter += 1
        }
    }
    
}
