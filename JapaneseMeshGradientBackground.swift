struct JapaneseMeshGradientBackground: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var t: Float = 0.0
    @State private var timer: Timer?
    
    var body: some View {
        Group {
            if colorScheme == .light {
                // Light mode: Animated white to red gradient
                MeshGradient(width: 3, height: 3, points: [
                    // Fixed top row
                    .init(0, 0), .init(0.5, 0), .init(1, 0),
                    
                    // Animated middle and bottom rows
                    [sinInRange(-0.2...0.2, offset: 0.439, timeScale: 0.142, t: t),
                     sinInRange(0.3...0.7, offset: 3.42, timeScale: 0.184, t: t)],
                    [sinInRange(0.4...0.6, offset: 0.239, timeScale: 0.084, t: t),
                     sinInRange(0.4...0.6, offset: 5.21, timeScale: 0.142, t: t)],
                    [sinInRange(0.8...1.2, offset: 0.939, timeScale: 0.084, t: t),
                     sinInRange(0.3...0.7, offset: 0.25, timeScale: 0.142, t: t)],
                    
                    [sinInRange(-0.2...0.2, offset: 1.439, timeScale: 0.142, t: t),
                     sinInRange(0.8...1.2, offset: 3.42, timeScale: 0.184, t: t)],
                    [sinInRange(0.4...0.6, offset: 0.339, timeScale: 0.184, t: t),
                     sinInRange(0.8...1.2, offset: 1.22, timeScale: 0.172, t: t)],
                    [sinInRange(0.8...1.2, offset: 0.939, timeScale: 0.056, t: t),
                     sinInRange(0.8...1.2, offset: 0.47, timeScale: 0.142, t: t)]
                ], colors: [
                    .white, .white, .white,                               // Top row: Pure white
                    Color(red: 1.0, green: 0.9, blue: 0.9),              // Middle row
                    Color(red: 0.98, green: 0.85, blue: 0.85),
                    Color(red: 0.95, green: 0.8, blue: 0.8),
                    Color(red: 0.95, green: 0.75, blue: 0.75),           // Bottom row
                    Color(red: 0.92, green: 0.70, blue: 0.70),
                    Color(red: 0.90, green: 0.65, blue: 0.65)
                ])
            } else {
                // Dark mode: Animated black to deep red gradient
                MeshGradient(width: 3, height: 3, points: [
                    // Fixed top row
                    .init(0, 0), .init(0.5, 0), .init(1, 0),
                    
                    // Animated middle and bottom rows
                    [sinInRange(-0.2...0.2, offset: 0.439, timeScale: 0.142, t: t),
                     sinInRange(0.3...0.7, offset: 3.42, timeScale: 0.184, t: t)],
                    [sinInRange(0.4...0.6, offset: 0.239, timeScale: 0.084, t: t),
                     sinInRange(0.4...0.6, offset: 5.21, timeScale: 0.142, t: t)],
                    [sinInRange(0.8...1.2, offset: 0.939, timeScale: 0.084, t: t),
                     sinInRange(0.3...0.7, offset: 0.25, timeScale: 0.142, t: t)],
                    
                    [sinInRange(-0.2...0.2, offset: 1.439, timeScale: 0.142, t: t),
                     sinInRange(0.8...1.2, offset: 3.42, timeScale: 0.184, t: t)],
                    [sinInRange(0.4...0.6, offset: 0.339, timeScale: 0.184, t: t),
                     sinInRange(0.8...1.2, offset: 1.22, timeScale: 0.172, t: t)],
                    [sinInRange(0.8...1.2, offset: 0.939, timeScale: 0.056, t: t),
                     sinInRange(0.8...1.2, offset: 0.47, timeScale: 0.142, t: t)]
                ], colors: [
                    .black, .black, .black,                              // Top row: Pure black
                    Color(red: 0.15, green: 0.08, blue: 0.08),          // Middle row
                    Color(red: 0.20, green: 0.10, blue: 0.10),
                    Color(red: 0.25, green: 0.12, blue: 0.12),
                    Color(red: 0.25, green: 0.12, blue: 0.12),          // Bottom row
                    Color(red: 0.30, green: 0.13, blue: 0.13),
                    Color(red: 0.35, green: 0.15, blue: 0.15)
                ])
            }
        }
        .ignoresSafeArea()
        .onAppear {
            // Start the animation timer
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                t += 0.02
            }
        }
        .onDisappear {
            // Clean up the timer when the view disappears
            timer?.invalidate()
            timer = nil
        }
    }
    
    func sinInRange(_ range: ClosedRange<Float>, offset: Float, timeScale: Float, t: Float) -> Float {
        let amplitude = (range.upperBound - range.lowerBound) / 2
        let midPoint = (range.upperBound + range.lowerBound) / 2
        return midPoint + amplitude * sin(timeScale * t + offset)
    }
}