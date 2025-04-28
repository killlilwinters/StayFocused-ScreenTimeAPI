//
//  ForegroundTracker.swift
//  DidYouDev
//
//  Created by Maks Winters on 27.04.2025.
//

import Combine
import UIKit

final class ForegroundTracker {
    static let shared = ForegroundTracker()
    
    private var executionItems: [() -> Void] = []
    var cancellables: Set<AnyCancellable> = .init()
    
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
    
    func addExecutionItem(_ item: @escaping () -> Void) {
        executionItems.append(item)
    }
    
    func removeAllExecutionItems() {
        executionItems.removeAll()
    }
    
}
