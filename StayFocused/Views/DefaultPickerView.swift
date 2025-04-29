//
//  DefaultPickerView.swift
//  StayFocused
//
//  Created by Maks Winters on 29.04.2025.
//

import SwiftUI

struct DefaultPickerView: View {
    
    @Binding var deadline: Date
    @State private var component: TimerDeadline = .init(hour: 0, minute: 0)
    
    var body: some View {
        
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
                    ForEach(Array(15...59), id: \.self) {
                        Text($0.description)
                    }
                }
                .pickerStyle(.wheel)
            }
        }
        .padding(.horizontal, 100)
        .frame(height: 100)
        .onChange(of: component) { () in setFromDefaultPicker() }
        .onAppear(perform: setFromDefaultPicker)
        
    }
    
    private func setFromDefaultPicker() {
        deadline = Date
            .appendingToCurrentDate(
                hour: component.hour,
                minute: component.minute
            )
    }
    
}

#Preview {
    DefaultPickerView(deadline: .constant(.now))
}
