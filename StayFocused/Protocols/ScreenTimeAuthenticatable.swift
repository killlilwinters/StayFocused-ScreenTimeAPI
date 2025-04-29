//
//  ScreenTimeAuthenticatable.swift
//  StayFocused
//
//  Created by Maks Winters on 29.04.2025.
//

/// Verifies Screen Time access has been granted.
///
/// - Throws: `ScreenTimeAuth.Error.notAuthorized` if last known status
///           is `.notDetermined` or `.denied`.
protocol ScreenTimeAuthenticatable {
    var checkAuthorization: Void { get throws }
}
