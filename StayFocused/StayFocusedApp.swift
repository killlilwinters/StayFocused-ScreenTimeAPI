//
//  StayFocusedApp.swift
//  StayFocused
//
//  Created by Maks Winters on 28.04.2025.
//
//  More on ScreenTime API restrictions:
//  https://letvar.medium.com/time-after-screen-time-part-3-the-device-activity-monitor-extension-284da931391b
//

import os.log
import SwiftUI
import SwiftData

private let appLogger = Logger(subsystem: "StayFocusedApp", category: "AppEntrypoint")

@main
struct StayFocusedApp: App {
    private let container: ModelContainer = {
        let schema = Schema([StoredActivity.self])
        let config = ModelConfiguration(groupContainer: .identifier(SharedConstants.groupIdentifier))
        do {
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            appLogger.error("Error during container initialization: \(error.localizedDescription)")
            fatalError()
        }
    }()
    
    @State private var authManager = ScreenTimeAuth()
    @State private var showOverlay = false {
        didSet {
            appLogger.log("showOverlay changed to a value of \(showOverlay)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(authManager: authManager, modelContainer: container)
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
