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

struct TimerDeadline: Equatable {
    var hour: Int
    var minute: Int
}

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
    
    @State private var isRunning = false
    @State private var isAnimatingBackground = true
    
    // Picker selection
    @State private var pickerStyle: PickerStyle = .defaultPicker
    
    // Default Picker
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var component: TimerDeadline = .init(hour: 0, minute: 0)
    
    @State private var date: Date = .now
    
    @State private var deadline: Date = .now
    
    var body: some View {
        // Set a timer to focus
        // Get Date.now()
        // On each .onAppear() calculate the amount of time passed
        // Use DeviceActivityMonitor to unlock apps upon the timer expiration
        // Add a time selector for user to set how much time he does want to
        // stay focused
        // Dynamic Island integration
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
                if !isRunning {
                    Picker("Pick a picker style", selection: $pickerStyle) {
                        ForEach(PickerStyle.allCases, id: \.self) { c in
                            Text(c.description)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 100)
                    .colorScheme(.dark)
                    .onChange(of: pickerStyle) { _, nv in
                        nv == .defaultPicker
                        ? setFromDefaultPicker()
                        : setFromDatePicker()
                    }
                }
                Spacer()
                TimerView(deadline: $deadline, isAnimating: $isRunning)
                
                if isRunning {
                    EmptyView()
                } else if pickerStyle == .datePicker {
                    datePicker
                        .onChange(of: date) { _, _ in setFromDatePicker() }
                } else {
                    defaultPicker
                        .onChange(of: component) { _, _ in setFromDefaultPicker() }
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        isRunning.toggle()
                        isAnimatingBackground = !isRunning
                    }
                } label: {
                    Text(isRunning ? "Stop" : "Start")
                        .bold()
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .foregroundStyle(.white)
                
            }
        }
    }
    
    var datePicker: some View {
        DatePicker("Please enter a time", selection: $date, in: Date.now..., displayedComponents: .hourAndMinute)
            .labelsHidden()
            .datePickerStyle(.wheel)
            .colorScheme(.dark)
            .frame(height: 100)
            .clipped()
    }
    
    var defaultPicker: some View {
        HStack {
            VStack(spacing: 0) {
                Text("Hour:")
                Picker("Select an hour", selection: $component.hour) {
                    ForEach(Array(0...24), id: \.self) {
                        Text($0.description)
                    }
                }
                .pickerStyle(.wheel)
            }
            VStack(spacing: 0) {
                Text("Minute:")
                Picker("Select an hour", selection: $component.minute) {
                    ForEach(Array(0...59), id: \.self) {
                        Text($0.description)
                    }
                }
                .pickerStyle(.wheel)
            }
        }
        .padding(.horizontal, 100)
        .frame(height: 100)
        .colorScheme(.dark)
    }
    
    private func setFromDefaultPicker() {
        deadline = Date
            .appendingToCurrentDate(
                hour: component.hour,
                minute: component.minute
            )
    }
    
    private func setFromDatePicker() {
        let cal = Calendar.current
        let now = Date()

        let desiredComponents = cal.dateComponents([.hour, .minute], from: date)
        guard let nextOccurrence = cal.nextDate(after: now,
                                                matching: desiredComponents,
                                                matchingPolicy: .nextTime) else {
            cwLogger.log("Error: Could not calculate the next matching time.")
            deadline = now
            return
        }

        guard let finalDeadline = cal.date(bySetting: .second, value: 0, of: nextOccurrence) else {
            cwLogger.log("Error: Could not zero out seconds for the deadline.")
            deadline = nextOccurrence
            return
        }

        self.deadline = finalDeadline
    }
    
}

#Preview {
    ContentView()
}
