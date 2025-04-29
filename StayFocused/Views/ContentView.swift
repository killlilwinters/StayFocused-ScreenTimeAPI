//
//  ContentView.swift
//  StayFocused
//
//  Created by Maks Winters on 28.04.2025.
//

import SwiftUI
import Combine
import FamilyControls
import os.log

private let cwLogger = Logger(subsystem: "ContentView", category: "View")

struct ContentView: View {
    enum PickerStyle: CaseIterable {
        case defaultPicker, datePicker
        
        var description: String {
            switch self {
            case .defaultPicker: "Default Picker"
            case .datePicker:    "Date Picker"
            }
        }
    }
    
    // Managers
    private let activityRegistration: ActivityRegistration
    private let immediateShield = ImmediateShield()
    
    // Choosing apps
    @State private var appListStorage = try! AppListStorage()
    @State private var isFamilyPickerPresented = false
    
    // Running
    @State private var isRunning = false
    @State private var isAnimatingBackground = true
    
    // Picker selection
    @State private var pickerStyle: PickerStyle = .defaultPicker

    // Final deadline value
    @State private var deadline: Date = .now
    
    var body: some View {
        // Dynamic Island integration
        // Come up with some UI for shield view
        ZStack {
            AuroraEffectView(
                colors: [.purple, .yellow, .cyan],
                backgroundTint: Color(white: 0.1),
                animating: $isAnimatingBackground,
                isGray: $isRunning,
                timerDuration: 3,
                animationSpeed: 10,
                blurRadius: 100,
                circleDiameterRatio: 1.5
            )
            VStack(spacing: 20) {
                
                if !isRunning { pickerPicker }
                
                Spacer()
                
                TimerView(deadline: $deadline, isAnimating: $isRunning)
                
                if !isRunning {
                    switch pickerStyle {
                    case .datePicker:
                        DatePickerView(deadline: $deadline)
                    case .defaultPicker:
                        DefaultPickerView(deadline: $deadline)
                    }
                }
                
                Spacer()
                
                Button(isRunning ? "Stop" : "Start") {
                    withAnimation {
                        isRunning.toggle()
                        isAnimatingBackground = !isRunning
                    }
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                
                Button("Choose apps") {
                    isFamilyPickerPresented.toggle()
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .familyActivityPicker(isPresented: $isFamilyPickerPresented, selection: $appListStorage.activitySelection)
                
            }
            .colorScheme(.dark)
            .onChange(of: isRunning) {
                isAnimatingBackground = !isRunning
                
                isRunning ? immediateShield.shield() : immediateShield.unshield()
                isRunning ? registerActivity() : unregisterActivity()
            }
        }
    }
    
    var pickerPicker: some View {
        Picker("Pick a picker style", selection: $pickerStyle) {
            ForEach(PickerStyle.allCases, id: \.self) { Text($0.description) }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 100)
    }
    
    init(authManager: ScreenTimeAuth) {
        self.activityRegistration = ActivityRegistration(authManager: authManager)
    }
    
    private func registerActivity() {
        let activity = RegisterActivity(
            "TimerInitiatedActivity",
            start: DateComponents.now,
            end: DateComponents.init(from: deadline),
            repeats: false
        )
        
        try? activityRegistration.register(activity)
    }
    
    private func unregisterActivity() {
        try? activityRegistration.remove("TimerInitiatedActivity")
    }

}

#Preview {
    ContentView(authManager: .init())
}
