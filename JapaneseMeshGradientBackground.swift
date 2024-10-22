//
//  JapaneseMeshGradientBackground.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 22.10.24.
//
import SwiftUI

struct JapaneseMeshGradientBackground: View {
    @State var t: Float = 0.0
    @State var timer: Timer?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        MeshGradient(width: 3, height: 3, points: [
            .init(0, 0), .init(0.5, 0), .init(1, 0),

            [sinInRange(-0.8...(-0.2), offset: 0.439, timeScale: 0.342, t: t),
             sinInRange(0.3...0.7, offset: 3.42, timeScale: 0.984, t: t)],
            [sinInRange(0.1...0.8, offset: 0.239, timeScale: 0.084, t: t),
             sinInRange(0.2...0.8, offset: 5.21, timeScale: 0.242, t: t)],
            [sinInRange(1.0...1.5, offset: 0.939, timeScale: 0.084, t: t),
             sinInRange(0.4...0.8, offset: 0.25, timeScale: 0.642, t: t)],
            
            [sinInRange(-0.8...0.0, offset: 1.439, timeScale: 0.442, t: t),
             sinInRange(1.4...1.9, offset: 3.42, timeScale: 0.984, t: t)],
            [sinInRange(0.3...0.6, offset: 0.339, timeScale: 0.784, t: t),
             sinInRange(1.0...1.2, offset: 1.22, timeScale: 0.772, t: t)],
            [sinInRange(1.0...1.5, offset: 0.939, timeScale: 0.056, t: t),
             sinInRange(1.3...1.7, offset: 0.47, timeScale: 0.342, t: t)]
        ], colors: [
            colorScheme == .dark ? Color.black : Color.white,
            colorScheme == .dark ? Color.black : Color.white,
            colorScheme == .dark ? Color.black : Color.white,
            
            Color(red: 0.12, green: 0.06, blue: 0.12),
            Color(red: 0.16, green: 0.08, blue: 0.16),
            Color(red: 0.20, green: 0.10, blue: 0.20),
            
            Color(red: 0.24, green: 0.12, blue: 0.24),
            Color(red: 0.28, green: 0.14, blue: 0.28),
            Color(red: 0.32, green: 0.16, blue: 0.32)
        ])
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .background(.black)
        .ignoresSafeArea()
    }
    
    private func startTimer() {
        // Invalidate existing timer if any
        stopTimer()
        
        // Create new timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            t += 0.02
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func sinInRange(_ range: ClosedRange<Float>, offset: Float, timeScale: Float, t: Float) -> Float {
        let amplitude = (range.upperBound - range.lowerBound) / 2
        let midPoint = (range.upperBound + range.lowerBound) / 2
        return midPoint + amplitude * sin(timeScale * t + offset)
    }
}
#Preview {
    JapaneseMeshGradientBackground()
}
