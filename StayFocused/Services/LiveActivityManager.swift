//
//  LiveActivityManager.swift
//  StayFocused
//
//  Created by Maks Winters on 02.05.2025.
//

import ActivityKit
import TimerActivityContent
import SwiftUI

@Observable
final class LiveActivityManager {
    private let activityAuthorizationInfo = ActivityAuthorizationInfo()
    private var currentActivity: Activity<TimerActivityAttributes>? = nil
    
    func startActivity(deadline: Date) {
        guard activityAuthorizationInfo.areActivitiesEnabled else { return }
        
        let range: ClosedRange<Date> = Date.now...deadline
        
        let attributes = TimerActivityAttributes()
        let state = TimerActivityAttributes.ContentState(deadlineRange: range)
        
        let content = ActivityContent(state: state, staleDate: nil)
        
        currentActivity = try? Activity
            .request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
    }
    
    
    func finishActivity() {
        guard let currentActivity else { return }
        
        let content = currentActivity.content
        
        Task {
            await currentActivity.end(content)
        }
    }
    
}
