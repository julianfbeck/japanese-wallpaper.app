import SwiftUI
import GoogleMobileAds


class TabBarVisibility: ObservableObject {
    @Published var isVisible: Bool = true
}

struct ContentView: View {
    @StateObject private var tabBarVisibility = TabBarVisibility()
    @EnvironmentObject private var globalViewModel: GlobalViewModel

    var body: some View {
        TabView {
            AllView()
                .tabItem {
                    Label("All", systemImage: "square.grid.2x2").environment(\.symbolVariants, .none)
                }
                .toolbar(tabBarVisibility.isVisible ? .visible : .hidden, for: .tabBar)

            NewView()
                .tabItem {
                    Label("New", systemImage: "star").environment(\.symbolVariants, .none)
                }
                .toolbar(tabBarVisibility.isVisible ? .visible : .hidden, for: .tabBar)

            DarkView()
                .tabItem {
                    Label("Dark", systemImage: "moon").environment(\.symbolVariants, .none)
                }
                .toolbar(tabBarVisibility.isVisible ? .visible : .hidden, for: .tabBar)


            TopView()
                .tabItem {
                    Label("Top", systemImage: "flame").environment(\.symbolVariants, .none)
                }
                .toolbar(tabBarVisibility.isVisible ? .visible : .hidden, for: .tabBar)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear").environment(\.symbolVariants, .none)
                }
                .toolbar(tabBarVisibility.isVisible ? .visible : .hidden, for: .tabBar)

        }
        .environmentObject(tabBarVisibility)
        
    }
}


struct AllView: View {
    @State private var wallpaperController = WallpaperController()
    @EnvironmentObject private var globalViewModel: GlobalViewModel

    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        // Horizontal scroll tip for first time users
                        if !globalViewModel.isPro && wallpaperController.categoriesLight.isEmpty == false {
                            HorizontalScrollTip()
                                .padding(.horizontal)
                        }

                        ForEach(wallpaperController.categoriesLight) { category in
                            CategoryWallpaperView(category: category)
                        }
                    }
                    .padding(.vertical)
                }
                .navigationTitle("All Wallpapers")
                .background(JapaneseMeshGradientBackground())
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if !globalViewModel.isPro {
                            Button(action: {
                                globalViewModel.isShowingPayWall = true
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 12))
                                    Text("PRO")
                                        .font(.system(size: 12, weight: .bold))
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }
                    }
                }
            }
            .refreshable {
                await wallpaperController.fetchCategoriesLight()
            }
            .task {
                await wallpaperController.fetchCategoriesLight()
            }
        }
    }
}




struct DarkView: View {
    @State private var wallpaperController = WallpaperController()
    @EnvironmentObject private var globalViewModel: GlobalViewModel
    @Namespace var namespace

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    // Horizontal scroll tip for first time users
                    if !globalViewModel.isPro && wallpaperController.categoriesDark.isEmpty == false {
                        HorizontalScrollTip()
                            .padding(.horizontal)
                    }

                    ForEach(wallpaperController.categoriesDark) { category in
                        CategoryWallpaperView(category: category)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Dark Mode")
            .background(JapaneseMeshGradientBackground())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !globalViewModel.isPro {
                        Button(action: {
                            globalViewModel.isShowingPayWall = true
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 12))
                                Text("PRO")
                                    .font(.system(size: 12, weight: .bold))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                }
            }
        }
        .refreshable {
            await wallpaperController.fetchCategoriesDark()
        }
        .task {
            await wallpaperController.fetchCategoriesDark()
        }
    }
}



struct HorizontalScrollTip: View {
    @State private var isVisible = true
    @State private var animationOffset: CGFloat = 0

    var body: some View {
        if isVisible {
            HStack(spacing: 8) {
                Image(systemName: "hand.point.left.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .offset(x: animationOffset)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animationOffset)

                Text("Swipe left and right to see more wallpapers")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)

                Spacer()

                Button(action: {
                    withAnimation {
                        isVisible = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.6))
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.orange.opacity(0.5), lineWidth: 1)
            )
            .onAppear {
                animationOffset = -10
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GlobalViewModel())
}
