//
//  TopView.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 20.10.24.
//

import SwiftUI

struct TopView: View {
    @State private var wallpaperController = WallpaperController()
    @State private var currentIndex: Int?
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        ForEach(Array(wallpaperController.topDownloads.enumerated()), id: \.element.id) { index, wallpaper in
                            WallpaperLatestCard(wallpaper: wallpaper)
                                .scrollTransition { content, phase in
                                    content
                                        .rotation3DEffect(
                                            .degrees(phase.isIdentity ? 0 : 60),
                                            axis: (x: 0, y: 1, z: 0)
                                        )
                                        .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                }
                                .id(index)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $currentIndex)
                .onChange(of: currentIndex) { oldValue, newValue in
                    if oldValue != newValue {
                        hapticFeedback()
                    }
                }
                .padding()
            }
            .navigationTitle("Latest Wallpapers")
            .background(JapaneseMeshGradientBackground())
        }
        .task {
            await wallpaperController.fetchTopDownloads()
        }
    }
    
    private func hapticFeedback() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}

