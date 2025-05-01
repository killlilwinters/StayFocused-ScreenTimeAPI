//
//  TimerActivityWidgetLiveActivity.swift
//  TimerActivityWidget
//
//  Created by Maks Winters on 01.05.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI
import TimerActivityUI
import TimerActivityContent

struct TimerActivityWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                ActivityTimerView(
                    attrs: context.attributes,
                    state: context.state
                )
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
//                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
//                Text("T \(context.state.emoji)")
            } minimal: {
//                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TimerActivityAttributes {
    fileprivate static var preview: TimerActivityAttributes {
        TimerActivityAttributes(date: .now)
    }
}

extension TimerActivityAttributes.ContentState {
    fileprivate static var running: TimerActivityAttributes.ContentState {
        TimerActivityAttributes.ContentState(hour: 1, minute: 1, second: 1)
     }
     
     fileprivate static var notRunning: TimerActivityAttributes.ContentState {
         TimerActivityAttributes.ContentState(hour: -1, minute: -1, second: -1)
     }
}

#Preview("Notification", as: .content, using: TimerActivityAttributes.preview) {
   TimerActivityWidgetLiveActivity()
} contentStates: {
    TimerActivityAttributes.ContentState.running
    TimerActivityAttributes.ContentState.notRunning
}

#Preview("Minimal Island", as: .dynamicIsland(.minimal), using: TimerActivityAttributes.preview) {
   TimerActivityWidgetLiveActivity()
} contentStates: {
    TimerActivityAttributes.ContentState.running
    TimerActivityAttributes.ContentState.notRunning
}

#Preview("Compact Island", as: .dynamicIsland(.compact), using: TimerActivityAttributes.preview) {
   TimerActivityWidgetLiveActivity()
} contentStates: {
    TimerActivityAttributes.ContentState.running
    TimerActivityAttributes.ContentState.notRunning
}

#Preview("Expanded Island", as: .dynamicIsland(.expanded), using: TimerActivityAttributes.preview) {
   TimerActivityWidgetLiveActivity()
} contentStates: {
    TimerActivityAttributes.ContentState.running
    TimerActivityAttributes.ContentState.notRunning
}
