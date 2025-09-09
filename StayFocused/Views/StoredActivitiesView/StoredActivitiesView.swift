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
                            ActivityCellView(activity: activity)
                        }
                        .padding(1)
                    }
                }
            }
        }
        .onAppear(perform: vm.fetchActivities)
    }
    
    init(storedActivityManager: StoredActivityManager) {
        self.vm = StoredActivitiesViewModel(storedActivityManager: storedActivityManager)
    }
    
}

#Preview {
    StoredActivitiesView(
        storedActivityManager: StoredActivityManager(
            modelContainer: PreviewHelper.inMemoryContainer
        )
    )
}
