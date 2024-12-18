//
//  SettingsView.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 23.10.24.
//


import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showAbout = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool?

    var body: some View {
        NavigationStack {
            List {
                // General Settings Section
                Section {
                    Button {
                        hasSeenOnboarding = false
                    } label: {
                        Label {
                            Text("Onboarding")
                        } icon: {
                            Image(systemName: "book.fill")
                                .foregroundStyle(.purple)
                        }
                    }
                    
                    
                } header: {
                    Text("General")
                }
                
                // App Info Section
                Section {
                    Button {
                        showAbout = true
                    } label: {
                        Label {
                            Text("About")
                        } icon: {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    
                    Link(destination: URL(string: "https://julianbeck.notion.site/Privacy-Policy-for-Japanese-wallpaper-app-12e96d29972e80d4a342d7882d1930d9?pvs=4")!) {
                        Label {
                            Text("Privacy Policy")
                        } icon: {
                            Image(systemName: "hand.raised.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    
                    Link(destination: URL(string: "https://julianbeck.notion.site/Japanese-Wallpapers-Terms-of-use-12e96d29972e80379694f55bb6780f04?pvs=4")!) {
                        Label {
                            Text("Terms of Use")
                        } icon: {
                            Image(systemName: "doc.text.fill")
                                .foregroundStyle(.orange)
                        }
                    }
                } header: {
                    Text("Information")
                }
                
                // Version Info
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("App Details")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // App Icon and Title
                    VStack(spacing: 15) {
                        Image(systemName: "mountain.2.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.red)
                        
                        Text("Japanese Wallpapers")
                            .font(.title.bold())
                        
                        Text("壁紙コレクション")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 30)
                    
                    // App Description
                    VStack(spacing: 20) {
                        descriptionBlock(
                            title: "Curated Collection",
                            description: "Carefully selected wallpapers inspired by Japanese art, culture, and aesthetics.",
                            icon: "star.fill"
                        )
                        
                        descriptionBlock(
                            title: "Daily Updates",
                            description: "New wallpapers added daily to keep your device fresh and inspiring.",
                            icon: "clock.fill"
                        )
                        
                        descriptionBlock(
                            title: "High Quality",
                            description: "All wallpapers are optimized for the latest devices with stunning resolution.",
                            icon: "sparkles"
                        )
                    }
                    .padding(.horizontal)
                    
                    // Credits
                    VStack(spacing: 10) {
                        Text("Developed with ♥️ in Germany")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
    
    private func descriptionBlock(title: String, description: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.red)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SettingsView()
}
