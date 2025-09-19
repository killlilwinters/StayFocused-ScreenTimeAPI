//
//  StoredActivitiesView.swift
//  StayFocused
//
//  Created by Maksym Horobets on 09.09.2025.
//

import SwiftUI

struct StoredActivitiesView: View {
    
    @State private var vm: StoredActivitiesViewModel
    
    var body: some View {
        ZStack {
            // Background
            Rectangle()
                .foregroundStyle(.ultraThinMaterial)
                .ignoresSafeArea()
            
            // List
            if vm.activities.isEmpty {
                ContentUnavailableView(
                    "No items yet.",
                    systemImage: "circle.dotted",
                    description: Text("Start block or add more items by pressing «+» on the top left.")
                )
            } else {
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(vm.activities) { activity in
                            ActivityCellView(
                                activity: activity,
                                isScheduled: .init(
                                    get: { vm.isScheduled(for: activity) },
                                    set: { vm.setIsScheduled(for: activity, isScheduled: $0) }
                                )
                            )
                            .contextMenu {
                                Button("Delete schedule", role: .destructive) {
                                    vm.deleteActivity(activity)
                                }
                            }
                        }
                        .padding(1)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear(perform: vm.fetchActivities)
        .alert(
            "Something went wrong...",
            isPresented: vm.isErrorPresented,
            actions: { /* Default OK button */ },
            message: { Text(vm.error?.localizedDescription ?? "Unknown error") }
        )
    }
    
    init(
        storedActivityManager: StoredActivityManager,
        registrationCenter: ActivityRegistrationCenter,
    ) {
        self.vm = StoredActivitiesViewModel(
            storedActivityManager: storedActivityManager,
            registrationCenter: registrationCenter
        )
    }
    
}

#Preview {
    StoredActivitiesView(
        storedActivityManager: PreviewHelper.mockStoredActivityManager,
        registrationCenter: PreviewHelper.mockActivityRegistrationCenter
    )
}
