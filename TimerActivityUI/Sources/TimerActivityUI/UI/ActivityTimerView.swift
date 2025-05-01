//
//  ActivityTimerView.swift
//  TimerActivityUI
//
//  Created by Maks Winters on 01.05.2025.
//

import SwiftUI
import TimerActivityContent

public struct ActivityTimerView: View {
    var attrs: TimerActivityAttributes
    var state: TimerActivityAttributes.ContentState
    
    public var body: some View {
        Text(timerInterval: Date()...attrs.date, countsDown: true)
    }
    
    public init(
        attrs: TimerActivityAttributes,
        state: TimerActivityAttributes.ContentState
    ) {
        self.attrs = attrs
        self.state = state
    }
}
