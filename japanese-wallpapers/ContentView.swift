import SwiftUI
import GoogleMobileAds


struct ContentView: View {
    var body: some View {
        TabView {
            AllView()
                .tabItem {
                    Label("All", systemImage: "square.grid.2x2").environment(\.symbolVariants, .none)
                }
            
            NewView()
                .tabItem {
                    Label("New", systemImage: "star").environment(\.symbolVariants, .none)
                }
            
            DarkView()
                .tabItem {
                    Label("Dark", systemImage: "moon").environment(\.symbolVariants, .none)
                }
            
            TopView()
                .tabItem {
                    Label("Top", systemImage: "flame").environment(\.symbolVariants, .none)
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear").environment(\.symbolVariants, .none)
                }
        }
    }
}

struct AllView: View {
    @State private var wallpaperController = WallpaperController()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(wallpaperController.categoriesLight) { category in
                        CategoryWallpaperView(category: category)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Wallpapers")
        }
        .refreshable {
            await wallpaperController.fetchCategoriesLight()
        }
        .task {
            await wallpaperController.fetchCategoriesLight()
        }
    }
}




struct DarkView: View {
    @State private var wallpaperController = WallpaperController()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(wallpaperController.categoriesDark) { category in
                        CategoryWallpaperView(category: category)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Wallpapers")
        }
        .refreshable {
            await wallpaperController.fetchCategoriesDark()
        }
        .task {
            await wallpaperController.fetchCategoriesDark()
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Text("Settings")
                .navigationTitle("Settings")
        }
    }
}

#Preview {
    ContentView()
}
