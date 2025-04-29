//
//  StayFocusedApp.swift
//  StayFocused
//
//  Created by Maks Winters on 28.04.2025.
//

import SwiftUI
import os.log

private let appLogger = Logger(subsystem: "StayFocusedApp", category: "AppEntrypoint")

@main
struct StayFocusedApp: App {
    
    @State private var authManager = ScreenTimeAuth()
    @State private var showOverlay = false {
        didSet {
            appLogger.log("showOverlay changed to a value of \(showOverlay)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(authManager: authManager)
                .onChange(of: authManager.status) {
                    do {
                        try authManager.checkAuthorization
                        showOverlay = false
                    } catch {
                        showOverlay = true
                    }
                }
                .overlay {
                    if showOverlay {
                        AuthView(authManager: authManager)
                            .transition(.blurReplace)
                    }
                }
        }
    }
}
