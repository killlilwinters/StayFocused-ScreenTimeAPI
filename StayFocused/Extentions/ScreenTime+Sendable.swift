//
//  ScreenTime+Sendable.swift
//  StayFocused
//
//  Created by Maksym Horobets on 08.09.2025.
//

import Foundation
import FamilyControls
import DeviceActivity

// This is just an enum wrapping a String rawValue so whatever.
extension DeviceActivityName: @retroactive @unchecked Sendable { }

// This is just a struct holding two DateComponents so whatever.
extension DeviceActivitySchedule: @retroactive @unchecked Sendable { }

// This one is a struct(value type) which is holding 3 sets of tokens, which are also struts.
// So I will assume we can copy this value across concurrency domains and leave it at that.
extension FamilyActivitySelection: @retroactive @unchecked Sendable { }
