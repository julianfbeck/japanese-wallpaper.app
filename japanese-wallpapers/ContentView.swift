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
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear").environment(\.symbolVariants, .none)
                }
        }
    }
}

struct AllView: View {
    var body: some View {
        NavigationView {
            Text("All Wallpapers")
                .navigationTitle("All")
        }
    }
}



struct DarkView: View {
    var body: some View {
        NavigationView {
            Text("Dark Mode Wallpapers")
                .navigationTitle("Dark")
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
