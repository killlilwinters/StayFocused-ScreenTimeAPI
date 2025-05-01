//
//  TimerActivityAttributes.swift
//  TimerActivityContent
//
//  Created by Maks Winters on 01.05.2025.
//

import Foundation
import ActivityKit

public struct TimerActivityAttributes: ActivityAttributes {
    
    // Fixed non-changing properties about your activity go here!
    public let date: Date
    
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        public var hour: Int
        public var minute: Int
        public var second: Int
        
        public init(hour: Int, minute: Int, second: Int) {
            self.hour = hour
            self.minute = minute
            self.second = second
        }
        
    }
    
    public init(date: Date) {
        self.date = date
    }
    
}
