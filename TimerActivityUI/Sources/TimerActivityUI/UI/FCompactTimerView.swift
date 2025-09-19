//
//  FCompactTimerView.swift
//  TimerActivityUI
//
//  Created by Maks Winters on 02.05.2025.
//

import SwiftUI
import TimerActivityContent
import WidgetKit

public struct FCompactTimerView: View {
    var attrs: TimerActivityAttributes
    var state: TimerActivityAttributes.ContentState
    
    public var body: some View {
        ProgressView(
            timerInterval: state.deadlineRange,
            label: { Text("") },
            currentValueLabel: { Text("") }
        )
        .progressViewStyle(CircularProgressViewStyle())
        .frame(width: 20, height: 20)
        .overlay {
            Image(systemName: "hourglass")
                .font(.caption)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .yellow],
                        startPoint: .top,
                        endPoint: .bottom
                    )
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
