//
//  ActivityTimerView.swift
//  TimerActivityUI
//
//  Created by Maks Winters on 01.05.2025.
//

import SwiftUI
import WidgetKit
import ActivityKit
import TimerActivityContent

public struct ActivityTimerView: View {
    var attrs: TimerActivityAttributes
    var state: TimerActivityAttributes.ContentState
    
    public var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            
            HStack {
                Text(timerInterval: state.deadlineRange, countsDown: true)
                    .foregroundStyle(.white)
                    .frame(width: width / 5)
                ProgressView(
                    timerInterval: state.deadlineRange,
                    countsDown: true,
                    label: { Text("") },
                    currentValueLabel: { Text("") }
                )
                .progressViewStyle(LinearProgressViewStyle())
                .tint(.white)
                .frame(height: 20)
                .scaleEffect(x: 1, y: 2.5, anchor: .center)
            }
            .position(
                x: width / 2,
                y: height / 2
            )
        }
    }
    
    public init(
        context: ActivityViewContext<TimerActivityAttributes>
    ) {
        self.attrs = context.attributes
        self.state = context.state
    }
}
