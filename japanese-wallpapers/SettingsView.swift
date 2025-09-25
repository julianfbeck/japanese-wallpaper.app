//
//  SettingsView.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 23.10.24.
//


import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var globalViewModel: GlobalViewModel
    @State private var showAbout = false
    @State private var showManageSubscriptions = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool?

    var body: some View {
        NavigationStack {
            List {
                // Premium Section
                Section {
                    if globalViewModel.isPro {
                        HStack {
                            Label {
                                Text("Premium Active")
                            } icon: {
                                Image(systemName: "crown.fill")
                                    .foregroundStyle(.orange)
                            }
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    } else {
                        Button {
                            globalViewModel.isShowingPayWall = true
                        } label: {
                            Label {
                                Text("Upgrade to Premium")
                            } icon: {
                                Image(systemName: "crown.fill")
                                    .foregroundStyle(.orange)
                            }
                        }
                    }

                    Button {
                        globalViewModel.restorePurchase()
                    } label: {
                        Label {
                            Text("Restore Purchases")
                        } icon: {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .foregroundStyle(.blue)
                        }
                    }

                    if globalViewModel.isPro {
                        Button {
                            showManageSubscriptions = true
                        } label: {
                            Label {
                                Text("Manage Subscription")
                            } icon: {
                                Image(systemName: "gearshape.fill")
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                } header: {
                    Text("Premium")
                }

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

                #if DEBUG
                // Debug Section
                Section {
                    Button {
                        globalViewModel.isPro.toggle()
                    } label: {
                        Label {
                            Text(globalViewModel.isPro ? "Disable Pro (Debug)" : "Enable Pro (Debug)")
                        } icon: {
                            Image(systemName: globalViewModel.isPro ? "xmark.circle.fill" : "checkmark.circle.fill")
                                .foregroundStyle(globalViewModel.isPro ? .red : .green)
                        }
                    }

                    Button {
                        globalViewModel.downloadCount = 0
                        globalViewModel.hasRemainingFreeDownloads = true
                    } label: {
                        Label {
                            Text("Reset Download Count")
                        } icon: {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .foregroundStyle(.orange)
                        }
                    }

                    HStack {
                        Label {
                            Text("Downloads Used")
                        } icon: {
                            Image(systemName: "number.circle.fill")
                                .foregroundStyle(.blue)
                        }
                        Spacer()
                        Text("\(globalViewModel.downloadCount)/\(globalViewModel.maxFreeDownloads)")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Debug")
                }
                #endif
                
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
            .sheet(isPresented: $showManageSubscriptions) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    ManageSubscriptionsView(windowScene: windowScene)
                }
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

struct ManageSubscriptionsView: UIViewControllerRepresentable {
    let windowScene: UIWindowScene

    func makeUIViewController(context: Context) -> UIViewController {
        let hostingController = UIHostingController(rootView:
            VStack {
                Text("Opening Subscription Management...")
                    .font(.headline)
                    .padding()
                ProgressView()
                    .padding()
            }
        )

        // Open subscription management
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            Task {
                do {
                    try await AppStore.showManageSubscriptions(in: windowScene)
                } catch {
                    print("Failed to show manage subscriptions: \(error)")
                }
            }
        }

        return hostingController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    SettingsView()
        .environmentObject(GlobalViewModel())
}
