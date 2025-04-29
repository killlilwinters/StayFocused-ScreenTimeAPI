//
//  ForegroundTracker.swift
//  DidYouDev
//
//  Created by Maks Winters on 27.04.2025.
//

import Combine
import UIKit

/// **ForegroundTracker** allows to add some synchronous code to execute before an app enters the foreground state.
final class ForegroundTracker {
    static let shared = ForegroundTracker()
    
    private var executionItems: Array<() -> Void>   = .init()
    private var cancellables:   Set<AnyCancellable> = .init()
    
    private init() {
        
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.executeItems()
            }
            .store(in: &cancellables)
        
    }
    
    private func executeItems() {
        for item in executionItems {
            item()
        }
    }
    
    /// Adds a piece of code to the queue which will execute before the app enters foreground.
    /// - Parameter item: Closure containing a synchronous code.
    func addExecutionItem(_ item: @escaping () -> Void) {
        executionItems.append(item)
    }
    
    /// Removes all execution items from the queue.
    func removeAllExecutionItems() {
        executionItems.removeAll()
    }
    
}
