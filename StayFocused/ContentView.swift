//
//  ContentView.swift
//  StayFocused
//
//  Created by Maks Winters on 28.04.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating = true
    @State private var isGray = false
    
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
    }
}

#Preview {
    ContentView()
}
