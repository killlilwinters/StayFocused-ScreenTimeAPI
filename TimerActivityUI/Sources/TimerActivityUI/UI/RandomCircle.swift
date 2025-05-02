//
//  RandomCircleUI.swift
//  TimerActivityUI
//
//  Created by Maks Winters on 02.05.2025.
//

import SwiftUI

public struct RandomCircleUI: View {
    
    public let amount: Int
    public let color: SwiftUICore.Color
    
    public var body: some View {
        GeometryReader { proxy in
            ForEach(0...amount, id: \.self) { _ in
                Circle()
                    .fill(color)
                    .opacity(
                        Double.random(in: 0.1...0.7)
                    )
                    .position(
                        x: Double.random(in: 0...proxy.size.width),
                        y: Double.random(in: 0...proxy.size.height)
                    )
                    .blur(radius: 3)
            }
        }
    }
    
    public init(
        amount: Int,
        color: SwiftUICore.Color
    ) {
        self.amount = amount
        self.color = color
    }
}
