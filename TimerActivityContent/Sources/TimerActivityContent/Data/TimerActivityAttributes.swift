//
//  TimerActivityAttributes.swift
//  TimerActivityContent
//
//  Created by Maks Winters on 01.05.2025.
//

import Foundation
import ActivityKit

public struct TimerActivityAttributes: ActivityAttributes {
    // Dynamic, changing properties go here
    public struct ContentState: Codable, Hashable {
        public let deadlineRange: ClosedRange<Date>
        
        public init(deadlineRange: ClosedRange<Date>) {
            self.deadlineRange = deadlineRange
        }
    }
    
    // Fixed non-changing properties go here
    
    public init() {}
}
