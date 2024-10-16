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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(adManager)
        }
    }
}

//struct ContentView: View {
//    @StateObject private var adManager = GlobalAdManager.shared
//    private let adViewControllerRepresentable = AdViewControllerRepresentable()
//    
//    var body: some View {
//        VStack {
//            Text("Interstitial Ad Example")
//                .font(.largeTitle)
//                .background(adViewControllerRepresentable)
//            
//            Button("Show Ad") {
//                adManager.showAd()
//            }
//            .disabled(!adManager.isAdReady)
//        }
//        .onAppear {
//            adManager.loadAd()
//        }
//    }
//}
