//
//  ActivityCellView.swift
//  StayFocused
//
//  Created by Maksym Horobets on 09.09.2025.
//

import SwiftUI

struct ActivityCellView: View {
    let activity: StoredActivity
    
    var isScheduled: Bool {
        switch activity.activityType {
        case .duration: false
        case .scheduled: true
        }
    }
    
    var body: some View {
        if #available(iOS 26, *) {
            baseView
                .glassEffect(.clear.interactive())
        } else {
            baseView
                .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 50)
                    .foregroundStyle(.ultraThinMaterial)
            }
        }
    }
    
    var baseView: some View {
        HStack(spacing: 20) {
            Image(systemName: isScheduled ? "hourglass" : "timer")
                .font(.title)
            VStack(alignment: .leading) {
                Text(activity.name)
                Text(activity.activityType.description)
            }
            Toggle("Is schedule enabled", isOn: .constant(false))
                .labelsHidden()
        }
        .padding()
    }
}

#Preview {
    ActivityCellView(activity: .mockDuration)
        .background {
            Image(.snowMylene2401)
        }
}
