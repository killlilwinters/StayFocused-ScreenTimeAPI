//
//  AuroraView.swift
//  StayFocused
//
//  Created by Maks Winters on 28.04.2025.
//
// Original author:
// https://medium.com/@danielgalasko/an-aurora-gradient-animation-in-swiftui-633fd4071b72
// The code was modernized to fit this project

import SwiftUI
import Combine
import os.log

let logger = Logger(subsystem: "AuroraView", category: "View")

@Observable
class CircleAnimator: ObservableObject {
    struct Circle: Identifiable {
        var position: CGPoint
        var id = UUID().uuidString
        var color: Color
    }

    private(set) var circles: [Circle] = []

    init(colors: [Color]) {
        circles = colors.map({ color in
            Circle(position: .init(x: CGFloat.random(in: 0 ... 1), y: CGFloat.random(in: 0 ... 1)), color: color)
        })
    }

    func animate() {
        objectWillChange.send()
        for i in 0..<circles.count {
            circles[i].position.x = CGFloat.random(in: 0 ... 1)
            circles[i].position.y = CGFloat.random(in: 0 ... 1)
        }
    }
}

struct AuroraEffectView: View {
    @Binding var isAnimating: Bool
    @Binding var isGray: Bool
    
    let animationSpeed: Double
    let timerDuration: TimeInterval
    let blurRadius: CGFloat
    let circleDiameterRatio: CGFloat
    let backgroundTint: Color?

    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @State private var animator: CircleAnimator

    var body: some View {
        GeometryReader { geometry in
            let smallestDimension = min(geometry.size.width, geometry.size.height)
            let circleDiameter = smallestDimension * circleDiameterRatio

            ZStack {
                ForEach(animator.circles) { circle in
                    SwiftUI.Circle()
                        .fill(isGray ? .gray : circle.color)
                        .frame(width: circleDiameter, height: circleDiameter)
                        .position(
                            x: geometry.size.width * circle.position.x,
                            y: geometry.size.height * circle.position.y
                        )
                }
            }
            .blur(radius: blurRadius)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundTint)
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .onAppear {
            animateCircles()
        }
        .onReceive(timer) { _ in
            guard isAnimating else { return }
            animateCircles()
        }
        .onChange(of: isAnimating) {
            animateCircles()
        }
        .edgesIgnoringSafeArea(.all)
    }

    private func animateCircles() {
        withAnimation(.easeInOut(duration: isAnimating ? animationSpeed : 0.5)) {
            animator.animate()
        }
    }

    init(colors:              [Color],
         backgroundTint:      Color?,
         animating:           Binding<Bool>,
         isGray:              Binding<Bool>,
         timerDuration:       TimeInterval = 1,
         animationSpeed:      Double = 4,
         blurRadius:          CGFloat = 15,
         circleDiameterRatio: CGFloat = 0.8) {
        
        self.backgroundTint      = backgroundTint
        self._animator           = State(wrappedValue: CircleAnimator(colors: colors))
        self._isAnimating        = animating
        self._isGray             = isGray
        self.timerDuration       = timerDuration
        self.animationSpeed      = animationSpeed
        self.blurRadius          = blurRadius
        self.circleDiameterRatio = circleDiameterRatio
        self.timer = Timer.publish(every: timerDuration, on: .main, in: .common).autoconnect()
    }
}

#Preview {
    AuroraEffectView(
        colors: [.blue, .green, .orange, .red],
        backgroundTint: .black,
        animating: .constant(true),
        isGray: .constant(false),
        timerDuration: 2,
        animationSpeed: 5,
        blurRadius: 80,
        circleDiameterRatio: 0.7
    )
}

#Preview("Larger Circles") {
    AuroraEffectView(
        colors: [.purple, .yellow, .cyan],
        backgroundTint: Color(white: 0.1),
        animating: .constant(true),
        isGray: .constant(false),
        timerDuration: 1.5,
        animationSpeed: 10,
        blurRadius: 100,
        circleDiameterRatio: 1.2
    )
}
