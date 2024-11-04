import SwiftUI
import GoogleMobileAds


class TabBarVisibility: ObservableObject {
    @Published var isVisible: Bool = true
}

struct ContentView: View {
    @StateObject private var tabBarVisibility = TabBarVisibility()
    
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

        }.environmentObject(tabBarVisibility)
        
    }
}


struct AllView: View {
    @State private var wallpaperController = WallpaperController()

    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(wallpaperController.categoriesLight) { category in
                            CategoryWallpaperView(category: category)
                        }
                    }
                    .padding(.vertical)
                }
                .navigationTitle("All Wallpapers")
                .background(JapaneseMeshGradientBackground())
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
    @Namespace var namespace
    
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
            .navigationTitle("Dark Mode")
            .background(JapaneseMeshGradientBackground())
        }
        .refreshable {
            await wallpaperController.fetchCategoriesDark()
        }
        .task {
            await wallpaperController.fetchCategoriesDark()
        }
    }
}



#Preview {
    ContentView()
}
