//
//  SwiftUIView.swift
//  TimerActivityUI
//
//  Created by Maks Winters on 02.05.2025.
//

import SwiftUI
import TimerActivityContent

struct FCompactTimerView: View {
    
    var body: some View {
        ProgressView(
            timerInterval: context.state.deadlineRange,
            label: { Text("") },
            currentValueLabel: { Text("") }
        )
            .progressViewStyle(CircularProgressViewStyle())
            .frame(width: 20, height: 20)
            .overlay {
                Text("F")
                    .bold()
                    .foregroundStyle(.white)
            }
    }
}

#Preview {
    SwiftUIView()
}
