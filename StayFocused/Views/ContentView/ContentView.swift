//
//  ContentView.swift
//  StayFocused
//
//  Created by Maks Winters on 28.04.2025.
//

import SwiftUI
import Combine
import SwiftData
import FamilyControls

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var vm: ContentViewModel
    
    var body: some View {
        // Make it so that the app fetches running activities upon launch
        ZStack {
            AuroraEffectView(
                colors: [.purple, .yellow, .cyan],
                backgroundTint: Color(white: 0.1),
                animating: $vm.isAnimatingBackground,
                isGray: $vm.isRunning,
                timerDuration: 3,
                animationSpeed: 10,
                blurRadius: 100,
                circleDiameterRatio: 1.5
            )
            VStack(spacing: 20) {
                
                if !vm.isRunning { pickerPicker }
                
                Spacer()
                
                TimerView(
                    deadline: $vm.deadline,
                    isAnimating: $vm.isRunning
                )
                
                if !vm.isRunning {
                    switch vm.pickerStyle {
                    case .datePicker:
                        DatePickerView(deadline: $vm.deadline)
                    case .defaultPicker:
                        DefaultPickerView(deadline: $vm.deadline)
                    }
                }
                
                Spacer()
                
                Button(vm.isRunning ? "Stop" : "Start") {
                    if vm.isRunning {
                        vm.endFocus()
                    } else {
                        vm.startFocus()
                    }
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                
                Button("Choose apps") {
                    vm.isFamilyPickerPresented.toggle()
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .familyActivityPicker(
                    isPresented: $vm.isFamilyPickerPresented,
                    selection: $vm.appListStorage.activitySelection
                )
                
            }
            .colorScheme(.dark)
            .onAppear {
                Task { await vm.restoreLastSessionTimer() }
            }
            .onChange(of: scenePhase) {
                if case .active = scenePhase {
                    vm.dismissLiveActivityIfNeeded()
                }
            }
        }
        .navigationTitle("StayFocused")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarItems }
        .overlay {
            if vm.isActivityListPresented {
                StoredActivitiesView(
                    storedActivityManager: vm.storedActivityManager,
                    registrationCenter: vm.registrationCenter
                )
                .transition(.opacity)
            }
        }
    }
    
    @ToolbarContentBuilder
    var toolbarItems: some ToolbarContent {
        if vm.isActivityListPresented {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    withAnimation {
#warning("Coming soon")
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.plain)
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                withAnimation {
                    vm.isActivityListPresented.toggle()
                }
            } label: {
                Image(systemName: "hourglass")
            }
            .buttonStyle(.plain)
        }
    }
    
    var pickerPicker: some View {
        Picker("Pick a picker style", selection: $vm.pickerStyle) {
            ForEach(ContentViewModel.PickerStyle.allCases, id: \.self) {
                Text($0.description) }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 100)
    }
    
    init(authManager: ScreenTimeAuth, modelContainer: ModelContainer) {
        self.vm = ContentViewModel(authManager: authManager, modelContainer: modelContainer)
    }
    
}

#Preview {
    NavigationStack {
        ContentView(authManager: .init(), modelContainer: PreviewHelper.inMemoryContainer)
    }
}
