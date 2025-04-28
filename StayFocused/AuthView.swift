//
//  AuthView.swift
//  StayFocused
//
//  Created by Maks Winters on 28.04.2025.
//

import SwiftUI

struct AuthView: View {
    
    let authManager: ScreenTimeAuth
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.ultraThinMaterial)
            VStack(spacing: 20) {
                Spacer()
                Text("Authorization required.")
                    .font(.system(size: 50, weight: .light))
                Spacer()
                Spacer()
                Text("Screen time authorization is required to use this app.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                Button("Authorize") {
                    try? authManager.authorize()
                }
                .padding(10)
                .buttonStyle(.plain)
                .background(.white)
                .foregroundStyle(.black)
                .clipShape(.capsule)
            }
            .padding(.horizontal, 10)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AuthView(authManager: .init())
}
