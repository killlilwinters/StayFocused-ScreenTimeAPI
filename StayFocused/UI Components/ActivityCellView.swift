//
//  ActivityCellView.swift
//  StayFocused
//
//  Created by Maksym Horobets on 09.09.2025.
//

import SwiftUI

struct ActivityCellView: View {
    let activity: StoredActivity
    @Binding var isScheduled: Bool
    
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
            Image(systemName: activity.activityType.iconSystemName)
                .font(.title)
            VStack(alignment: .leading) {
                Text(activity.name)
                Text(activity.activityType.description)
            }
            Toggle("Is schedule enabled", isOn: $isScheduled)
                .labelsHidden()
                .disabled({
                    if case .scheduled = activity.activityType {
                        return false
                    } else {
                        return true
                    }
                }())
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    ActivityCellView(activity: .mockDuration, isScheduled: .constant(true))
        .background {
            Image(.snowMylene2401)
        }
}
