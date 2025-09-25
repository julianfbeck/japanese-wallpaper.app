//
//  japanese_wallpapersApp.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 14.10.24.
//

import SwiftUI
import RevenueCat

@main
struct YourApp: App {
    @StateObject private var globalViewModel = GlobalViewModel()
    @StateObject private var adManager = GlobalAdManager.shared

    init() {
        Purchases.configure(withAPIKey: "appl_DPbifChwFxrGJORLhigNibkbSGg")
    }

    var body: some Scene {
        WindowGroup {
            Group {

                if globalViewModel.isShowingOnboarding {
                    OnboardingView()
                } else {
                    ContentView()
                }
            }
            .environmentObject(globalViewModel)
            .environmentObject(adManager)
            .onAppear {
                Plausible.shared.configure(domain: "japanese-wallpaper.julianbeck.com", endpoint: "https://stats.juli.sh/api/event")
            }
            .fullScreenCover(isPresented: $globalViewModel.isShowingPayWall) {
                PayWallView()
                    .environmentObject(globalViewModel)
            }
        }
    }
}

