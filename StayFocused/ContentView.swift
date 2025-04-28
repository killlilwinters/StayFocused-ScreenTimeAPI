//
//  ContentView.swift
//  StayFocused
//
//  Created by Maks Winters on 28.04.2025.
//

import SwiftUI
import Combine
import os.log

private let cwLogger = Logger(subsystem: "ContentView", category: "View")

struct ContentView: View {
    @State private var isAnimating = true
    @State private var isGray = false
    
    @State private var hour: String = "XX"
    @State private var minute: String = "XX"
    @State private var second: String = "XX"
    
    @State private var timer = Timer.publish(every: 1.0, on: .current, in: .common).autoconnect()
    
    var body: some View {
        // Set a timer to focus
        // Get Date.now()
        // On each .onAppear() calculate the amount of time passed
        // Use DeviceActivityMonitor to unlock apps upon the timer expiration
        // Add a time selector for user to set how much time he does want to
        // stay focused
        ZStack {
            AuroraEffectView(
                colors: [.purple, .yellow, .cyan],
                backgroundTint: Color(white: 0.1),
                animating: $isAnimating,
                isGray: $isGray,
                timerDuration: 3,
                animationSpeed: 10,
                blurRadius: 100,
                circleDiameterRatio: 1.5
            )
            VStack {
                HStack {
                    Text(hour)
                        .redacted(reason: hour == "XX" ? .placeholder : [])
                    Text(":")
                    Text(minute)
                        .redacted(reason: minute == "XX" ? .placeholder : [])
                    Text(":")
                    Text(second)
                        .redacted(reason: second == "XX" ? .placeholder : [])
                }
                .font(.system(size: 60, weight: .thin, design: .default))
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                Button(isAnimating ? "Stop" : "Start") {
                    withAnimation {
                        isAnimating.toggle()
                        isGray = !isAnimating
                    }
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .foregroundStyle(.white)
            }
            .onReceive(timer) { _ in
                guard isAnimating else { return }
                let now = Date.now
                withAnimation {
                    hour = now.formatted(.dateTime.hour(.twoDigits(amPM: .omitted)))
                    minute = now.formatted(.dateTime.minute(.twoDigits))
                    second = now.formatted(.dateTime.second(.twoDigits))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
