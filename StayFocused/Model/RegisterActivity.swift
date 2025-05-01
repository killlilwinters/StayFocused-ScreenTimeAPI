//
//  RegisterActivity.swift
//  StayFocused
//
//  Created by Maks Winters on 29.04.2025.
//
// More on restrictions:
// https://letvar.medium.com/time-after-screen-time-part-3-the-device-activity-monitor-extension-284da931391b
//

import Foundation
import DeviceActivity

struct RegisterActivity {
    
    let name: DeviceActivityName
    let schedule: DeviceActivitySchedule

    #warning("Activities, created less than 15 minutes into the future get omited by the system.")
    init(_ identifier: String, start: DateComponents, end: DateComponents, repeats: Bool) {
        self.name = DeviceActivityName(rawValue: identifier)
        self.schedule = DeviceActivitySchedule(
            intervalStart: start,
            intervalEnd: end,
            repeats: repeats
        )
    }
    
}
