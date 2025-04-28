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
final class ScreenTimeAuth {
    enum Error: LocalizedError {
        case notAuthorized, authorizationDenied
        
        var errorDescription: String? {
            switch self {
            case .notAuthorized:       "ScreenTime not authorized"
            case .authorizationDenied: "Authorization denied"
            }
        }
    }
    
    var status: AuthorizationStatus = .notDetermined
    
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
