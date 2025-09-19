//
//  TimerView.swift
//  StayFocused
//
//  Created by Maks Winters on 28.04.2025.
//

import SwiftUI

struct TimerView: View {
    
    @Binding var deadline: Date
    @Binding var isAnimating: Bool
    
    @State private var timer = Timer
        .publish(every: 1.0, on: .current, in: .common)
        .autoconnect()
    
    @State private var hour: Int = -1
    @State private var minute: Int = -1
    @State private var second: Int = -1
    
    /// Total seconds left (never negative)
    private var remainingSeconds: TimeInterval {
        max(0, deadline.timeIntervalSince(.now))
    }
    
    /// Fraction completed (0...1)
    private var progress: Double {
        let total = deadline.timeIntervalSince(.now)
        return total > 0 ? remainingSeconds / total : 0
    }
    
    var body: some View {
        HStack {
            Text(String(format: "%02d", hour))
                .redacted(reason: hour == -1 ? .placeholder : [])
            Text(":")
            Text(String(format: "%02d", minute))
                .redacted(reason: minute == -1 ? .placeholder : [])
            Text(":")
            Text(String(format: "%02d", second))
                .redacted(reason: second == -1 ? .placeholder : [])
        }
        .font(.system(size: 60, weight: .thin, design: .default))
        .foregroundStyle(.white)
        .contentTransition(.numericText())
        .onChange(of: isAnimating) {
            if isAnimating { startTimer() }
        }
        .onReceive(timer) { _ in
            handleTimerTick()
        }
    }
    
    private func handleTimerTick() {
        guard remainingSeconds > 0 else {
            withAnimation { isAnimating = false }
            return
        }
        
        guard isAnimating else {
            stopTimer()
            resetValues()
            return
        }
        
        withAnimation {
            hour = Int(remainingSeconds) / 3600
            minute = (Int(remainingSeconds) % 3600) / 60
            second = Int(remainingSeconds) % 60
        }
    }
    
    private func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
    private func startTimer() {
        timer = timer.upstream.autoconnect()
    }
    
    private func resetValues() {
        hour = -1
        minute = -1
        second = -1
    }
    
}

#Preview {
    TimerView(deadline: .constant(.now), isAnimating: .constant(false))
}
