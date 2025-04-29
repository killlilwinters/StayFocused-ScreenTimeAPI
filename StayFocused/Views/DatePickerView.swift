//
//  DatePickerView.swift
//  StayFocused
//
//  Created by Maks Winters on 29.04.2025.
//

import SwiftUI
import os.log

let dpLogger = Logger(subsystem: "DatePickerView", category: "View")

struct DatePickerView: View {
    
    @Binding var deadline: Date
    @State private var date: Date = .now
    
    var body: some View {
        
        DatePicker(
            "Please enter a time",
            selection: $date,
            in: Date.now.addingTimeInterval(15 * 60)...,
            displayedComponents: .hourAndMinute
        )
        .labelsHidden()
        .datePickerStyle(.wheel)
        .frame(height: 100)
        .clipped()
        .onChange(of: date) { () in setFromDatePicker() }
        .onAppear(perform: setFromDatePicker)
        
    }
    
    private func setFromDatePicker() {
        let cal = Calendar.current
        let now = Date()
        
        let desiredComponents = cal.dateComponents([.hour, .minute], from: date)
        guard let nextOccurrence = cal.nextDate(after: now,
                                                matching: desiredComponents,
                                                matchingPolicy: .nextTime) else {
            dpLogger.log("Error: Could not calculate the next matching time.")
            deadline = now
            return
        }
        
        guard let finalDeadline = cal.date(bySetting: .second, value: 0, of: nextOccurrence) else {
            dpLogger.log("Error: Could not zero out seconds for the deadline.")
            deadline = nextOccurrence
            return
        }
        
        self.deadline = finalDeadline
    }
    
}

#Preview {
    DatePickerView(deadline: .constant(.now))
}
