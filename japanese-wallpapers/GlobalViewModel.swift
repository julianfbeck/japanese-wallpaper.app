//
//  GlobalViewModel.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 25.09.25.
//

import Foundation
import RevenueCat

class GlobalViewModel: ObservableObject {
    @Published var offering: Offering?
    @Published var customerInfo: CustomerInfo?
    @Published var isPurchasing = false
    @Published var errorMessage: String?
    @Published var isShowingPayWall = false
    @Published var isShowingOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(!isShowingOnboarding, forKey: "hasSeenOnboarding")

            // Show paywall after onboarding is dismissed (only for non-pro users)
            if oldValue == true && isShowingOnboarding == false && !isPro {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isShowingPayWall = true
                }
            }
        }
    }
    @Published var isShowingRatings = false

    @Published var isPro: Bool {
        didSet {
            UserDefaults.standard.set(isPro, forKey: "isPro")
        }
    }

    // Persistent wallpaper download tracking
    @Published var downloadCount: Int {
        didSet {
            UserDefaults.standard.set(downloadCount, forKey: featureKey)
        }
    }

    @Published var hasRemainingFreeDownloads: Bool

    let maxFreeDownloads: Int = 3
    private let featureKey = "wallpaperDownloadCount"

    // Track if this is the first launch
    private var isFirstLaunch: Bool {
        return isShowingOnboarding
    }

    init() {
        // Initialize all properties from stored values first
        self.isPro = UserDefaults.standard.bool(forKey: "isPro")
        self.isShowingOnboarding = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

        // Get download count from UserDefaults
        let storedDownloadCount = UserDefaults.standard.integer(forKey: featureKey)

        // Initialize both properties directly
        self.downloadCount = storedDownloadCount
        self.hasRemainingFreeDownloads = storedDownloadCount < maxFreeDownloads

        setupPurchases()
        fetchOfferings()

        // Show paywall on every app launch for non-pro users after onboarding (but not immediately after first onboarding)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
            if !self.isPro && !self.isShowingOnboarding && !isFirstLaunch {
                self.isShowingPayWall = true
            }
        }
    }

    private func setupPurchases() {
        self.isPro = UserDefaults.standard.bool(forKey: "isPro")
        Purchases.shared.getCustomerInfo { [weak self] (customerInfo, _) in
            DispatchQueue.main.async {
                let isProActive = customerInfo?.entitlements["PRO"]?.isActive == true
                UserDefaults.standard.set(isProActive, forKey: "isPro")
                self?.isPro = isProActive
            }
        }
    }

    private func fetchOfferings() {
        Purchases.shared.getOfferings { [weak self] (offerings, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if let defaultOffering = offerings?.offering(identifier: "defaul") {
                    self?.offering = defaultOffering
                }
            }
        }
    }

    func purchase(package: Package) {
        isPurchasing = true
        Purchases.shared.purchase(package: package) { [weak self] (_, customerInfo, _, userCancelled) in
            DispatchQueue.main.async {
                self?.isPurchasing = false
                if let isProActive = customerInfo?.entitlements["PRO"]?.isActive {
                    self?.updateProStatus(isProActive)
                }
            }
        }
    }

    func restorePurchase() {
        Purchases.shared.restorePurchases { [weak self] customerInfo, _ in
            let isProActive = customerInfo?.entitlements["PRO"]?.isActive == true
            self?.updateProStatus(isProActive)
        }
    }

    private func updateProStatus(_ isPro: Bool) {
        self.isPro = isPro
        UserDefaults.standard.set(isPro, forKey: "isPro")
        if isPro {
            self.isShowingPayWall = false
        }
    }

    func recordDownload() {
        downloadCount += 1
        hasRemainingFreeDownloads = downloadCount < maxFreeDownloads
    }

    // For pro users: unlimited downloads without ads
    // For free users: up to 3 downloads with ads, then paywall
    func canDownloadWithoutPurchase() -> Bool {
        return isPro || hasRemainingFreeDownloads
    }

    // Pro users never need ads, free users need ads for their 3 downloads
    func needsAdForDownload() -> Bool {
        return !isPro
    }

    // Show paywall when free downloads exhausted and not pro
    func shouldShowPaywall() -> Bool {
        return !isPro && !hasRemainingFreeDownloads
    }

    // Return remaining free downloads (only relevant for non-pro users)
    var remainingFreeDownloads: Int {
        return max(0, maxFreeDownloads - downloadCount)
    }
}
