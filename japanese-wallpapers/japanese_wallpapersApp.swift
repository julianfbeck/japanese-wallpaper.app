//
//  japanese_wallpapersApp.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 14.10.24.
//

import SwiftUI

@main
struct YourApp: App {
    @StateObject private var adManager = GlobalAdManager.shared
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
  
    var body: some Scene {
        WindowGroup {
            Group {
                
                if self.hasSeenOnboarding {
                    ContentView()
                } else {
                    OnboardingView()
                }
            }
            .environmentObject(adManager)
            .onAppear {
                Plausible.shared.configure(domain: "japanese-wallpaper.julianbeck.com", endpoint: "https://stats.juli.sh/api/event")
            }
        }
    }
}

