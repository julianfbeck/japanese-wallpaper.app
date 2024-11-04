//
//  NewView.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 16.10.24.
//

import SwiftUI

struct NewView: View {
    @EnvironmentObject private var tabBarVisibility: TabBarVisibility
    @State private var wallpaperController = WallpaperController()
    @State private var currentIndex: Int?
    @Namespace private var namespace
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()
                    .onAppear {
                        tabBarVisibility.isVisible = true
                    }

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        ForEach(Array(wallpaperController.latestScreenshots.enumerated()), id: \.element.id) { index, wallpaper in
                            WallpaperLatestCard(wallpaper: wallpaper, namespace: namespace)
                                .frame(height: UIScreen.main.bounds.height * 0.7)
                                .padding(.horizontal)
                                .scrollTransition(.animated.threshold(.visible(0.5))) { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1.0 : 0.85)
                                        .scaleEffect(phase.isIdentity ? 1.0 : 0.92)
                                        .blur(radius: phase.isIdentity ? 0 : 1)
                                        .offset(y: phase.isIdentity ? 0 : phase.value > 0 ? 30 : -30)
                                }
                                .id(index)
                        }
                        .padding(.top, 16)
                    }
                }
                .scrollPosition(id: $currentIndex)
                .onChange(of: currentIndex) { oldValue, newValue in
                    if oldValue != newValue {
                        hapticFeedback()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New Wallpapers")
                        .font(.system(size: 18, weight: .semibold))
                }
            }
        }
        .task {
            await wallpaperController.fetchLatestScreenshots()
        }
    }
    
    private func hapticFeedback() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}




#Preview() {
    NewView()
}
