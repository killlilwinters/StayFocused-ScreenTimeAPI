//
//  ScheduleCreationView.swift
//  StayFocused
//
//  Created by Maksym Horobets on 10.09.2025.
//

import SwiftUI
import FamilyControls

struct ScheduleCreationView: View {
    
    let onFinishCreating: (StoredActivity?) -> Void
    @State private var vm: ScheduleCreationViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Create schedule").fontWeight(.light)
                .padding(.bottom)
            
            TextField("Set a name", text: $vm.name)
                .textFieldStyle(.glassy)
                .padding(.horizontal)
            
            Button {
                vm.isActivitySelectionPresented.toggle()
            } label: {
                Text("Pick activities")
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.primary)
            
            HStack {
                DatePicker(
                    "Start time",
                    selection: $vm.startTime,
                    displayedComponents: .hourAndMinute
                )
                Text(" - ")
                DatePicker(
                    "End time",
                    selection: $vm.endTime,
                    displayedComponents: .hourAndMinute
                )
            }
            .datePickerStyle(.compact)
            .labelsHidden()
            
            VStack {
                Button {
                    onFinishCreating(try? vm.constructActivity())
                } label: {
                    Text("Save")
                        .padding(.horizontal)
                }
                .buttonStyle(.bordered)
                
                Button("Cancel") {
                    onFinishCreating(nil)
                }
            }
            .foregroundStyle(.primary)
        }
        .padding()
        .buttonBorderShape(.capsule)
        .conditionalBackground()
        .familyActivityPicker(
            isPresented: $vm.isActivitySelectionPresented,
            selection: $vm.activitySelection
        )
        .colorScheme(.light)
    }
    
    init(onFinishCreating: @escaping (StoredActivity?) -> Void) {
        self.onFinishCreating = onFinishCreating
        self.vm = ScheduleCreationViewModel()
    }
    
}

fileprivate extension View {
    @ViewBuilder
    func conditionalBackground() -> some View {
        let rect = RoundedRectangle(cornerRadius: 40)
        
        if #available(iOS 26, *) {
            self.glassEffect(in: rect).padding()
        } else {
            self.background {
                rect.padding(.horizontal).foregroundStyle(.ultraThinMaterial)
            }
        }
    }
}

#Preview {
    ScheduleCreationView { storedActivity in
        print("Got: \(String(describing: storedActivity))")
    }
    .background {
        Image(.snowMylene2401)
    }
}
