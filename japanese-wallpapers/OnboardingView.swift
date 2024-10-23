//
//  OnboardingView.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 23.10.24.
//


import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var currentPage = 0
    
    let pages: [OnboardingPage] = [
           OnboardingPage(
               title: "Minimalist Art",
               subtitle: "ミニマルアート",
               description: "Clean, elegant minimalist Japanese-inspired designs.",
               wallpapers: [
                   "minimaru_00002_downscaled",
                   "minimaru_00003_downscaled",
                   "monokuro_00004_downscaled"
               ],
               accentColor: .red
           ),
           OnboardingPage(
               title: "Traditional Style",
               subtitle: "伝統的なスタイル",
               description: "Beautiful artworks inspired by Japanese culture.",
               wallpapers: [
                   "sumieart_00002_downscaled",
                   "tokai_00007_downscaled",
                   "ukiyoe_00002_downscaled"
               ],
               accentColor: .purple
           ),
           OnboardingPage(
               title: "Seasonal Beauty",
               subtitle: "季節の美しさ",
               description: "Experience the beauty of Japanese seasons.",
               wallpapers: [
                   "kisetsu_00004_downscaled",
                   "tsukimi_00004_downscaled",
                   "gekkouen_00002_downscaled"
               ],
               accentColor: .blue
           ),
           OnboardingPage(
               title: "Fantasy World",
               subtitle: "ファンタジーワールド",
               description: "Discover magical Japanese-inspired worlds.",
               wallpapers: [
                   "uchuu_00001_downscaled",
                   "yorunomachi_00002_downscaled",
                   "youkaiworld_00012_downscaled"
               ],
               accentColor: .indigo
           )
       ]
    
    var body: some View {
        ZStack {
            // Background gradient
            JapaneseMeshGradientBackground()
                .opacity(0.3)
            
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Navigation controls
            VStack {
                Spacer()
                
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(pages.indices, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? pages[index].accentColor : .gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1)
                            .animation(.spring(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 20)
                
                // Get Started button
                Button {
                    withAnimation {
                        if currentPage < pages.count - 1 {
                            currentPage += 1
                        } else {
                            hasSeenOnboarding = true
                        }
                    }
                } label: {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(pages[currentPage].accentColor.gradient)
                        }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let wallpapers: [String]
    let accentColor: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack {
            // Text content
            VStack(spacing: 12) {
                Text(page.title)
                    .font(.title.bold())
                
                Text(page.subtitle)
                    .font(.title2)
                    .foregroundStyle(page.accentColor)
            }
            .padding(.top, 60)
            
            Spacer()
            
            // Centered Wallpaper showcase
            WallpaperShowcase(wallpapers: page.wallpapers)
                .padding(.horizontal)
            
            Spacer()
            
            // Empty space for the bottom controls
            Color.clear
                .frame(height: 100)
        }
        .contentTransition(.opacity)
    }
}

struct WallpaperShowcase: View {
    let wallpapers: [String]
    @State private var selectedImage: Int = 1
    
    var body: some View {
        ZStack {
            // Background wallpapers (smaller)
            ForEach(wallpapers.indices, id: \.self) { index in
                if index != selectedImage {
                    WallpaperView(imageName: wallpapers[index])
                        .frame(width: 240, height: 480)
                        .scaleEffect(0.7)
                        .offset(x: CGFloat(index - selectedImage) * 180)
                        .opacity(0.7)
                }
            }
            
            // Selected wallpaper (larger)
            WallpaperView(imageName: wallpapers[selectedImage])
                .frame(width: 240, height: 480)
                .shadow(radius: 20)
//                .onTapGesture {
//                    withAnimation(.spring(duration: 0.5)) {
//                        selectedImage = (selectedImage + 1) % wallpapers.count
//                    }
//                }
        }
        .frame(height: 400)
    }
}

struct WallpaperView: View {
    let imageName: String
    
    var body: some View {
        // Replace Image with AsyncImage if loading from URL
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            )
    }
}

// Preview Support
#Preview {
    OnboardingView()
}

