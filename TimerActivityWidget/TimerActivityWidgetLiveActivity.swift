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
    
    let colors: Array<Color> = [
        .red,
        .purple,
        .green,
        .yellow,
        .blue
    ]
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            ZStack {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                RandomCircleUI(
                    amount: 5,
                    color: colors.randomElement()!
                )
                VStack {
                    HStack {
                        Text("Time remaining:")
                        Spacer()
                        Text("StayFocused")
                            .bold()
                    }
                    .foregroundStyle(.white)
                    ActivityTimerView(
                        attrs: context.attributes,
                        state: context.state
                    )
                    .display
                }
                .padding(
                    EdgeInsets(
                        top: 15,
                        leading: 15,
                        bottom: 20,
                        trailing: 15
                    )
                )
            }
            .activityBackgroundTint(.black)
            .activitySystemActionForegroundColor(.black)

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
        TimerActivityAttributes()
    }
}

extension TimerActivityAttributes.ContentState {
    fileprivate static var main: TimerActivityAttributes.ContentState {
        TimerActivityAttributes.ContentState(deadlineRange: Date.now...Date.now.addingTimeInterval(15 * 60))
     }
}

#Preview("Notification", as: .content, using: TimerActivityAttributes.preview) {
   TimerActivityWidgetLiveActivity()
} contentStates: {
    TimerActivityAttributes.ContentState.main
}

#Preview("Minimal Island", as: .dynamicIsland(.minimal), using: TimerActivityAttributes.preview) {
   TimerActivityWidgetLiveActivity()
} contentStates: {
    TimerActivityAttributes.ContentState.main
}

#Preview("Compact Island", as: .dynamicIsland(.compact), using: TimerActivityAttributes.preview) {
   TimerActivityWidgetLiveActivity()
} contentStates: {
    TimerActivityAttributes.ContentState.main
}

#Preview("Expanded Island", as: .dynamicIsland(.expanded), using: TimerActivityAttributes.preview) {
   TimerActivityWidgetLiveActivity()
} contentStates: {
    TimerActivityAttributes.ContentState.main
}
