//
//  ScreenTimeAuth.swift
//  StayFocused
//
//  Created by Maks Winters on 28.04.2025.
//

import FamilyControls
import UIKit
import Combine

@Observable
final class ScreenTimeAuth: ScreenTimeAuthenticatable {
    
    enum Error: LocalizedError {
        case notAuthorized, authorizationDenied
        
        var errorDescription: String? {
            switch self {
            case .notAuthorized:       "ScreenTime not authorized"
            case .authorizationDenied: "Authorization denied"
            }
        }
    }
    
    /// Used to check the last documented status of the authorization.
    /// > Important: This value may not reliably tell the authorization status,
    /// > make sure to call `authorize()` whenever appropriate to reset this value.
    private(set) var status: AuthorizationStatus = .notDetermined
    
    /// Used to check if the app requires authorization.
    /// If it does - this property will throw a `.notAuthorized` error.
    /// > Important: This value may not reliably tell the authorization status,
    /// > make sure to call `authorize()` whenever appropriate to reset this value.
    var checkAuthorization: Void {
        get throws {
            if status == .notDetermined || status == .denied {
                throw ScreenTimeAuth.Error.notAuthorized
            }
        }
    }
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        AuthorizationCenter.shared
          .$authorizationStatus
          .sink { [weak self] in
              self?.status = $0
          }
          .store(in: &cancellables)
        
        ForegroundTracker.shared.addExecutionItem { [weak self] in
            try? self?.authorize()
        }
    }

    /// Used to send the authorization request to the Screen Time API.
    /// After calling this method - the properties of the class get updated to the latest authorization status.
    func authorize() throws(ScreenTimeAuth.Error) {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            } catch {
                status = .denied
                throw ScreenTimeAuth.Error.authorizationDenied
            }
        }
        status = AuthorizationCenter.shared.authorizationStatus
    }
    
}
