import SwiftUI
import GoogleMobileAds
import UIKit

import SwiftUI
import Combine

class GlobalAdManager: ObservableObject {
    static let shared = GlobalAdManager()
    private let coordinator = InterstitialAdCoordinator()
    
    @Published var isAdReady = false
    @Published var isAdShown = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        #if DEBUG
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "28716d5496bfdc5958be9b599af8ceeb" ]
        #endif
        setupAdLoadingObserver()
        loadAd()
    }
    
    private func setupAdLoadingObserver() {
        $isAdReady
            .sink { [weak self] ready in
                if !ready {
                    self?.loadAd()
                }
            }
            .store(in: &cancellables)
    }
    
    func loadAd() {
        coordinator.loadAd { [weak self] success in
            DispatchQueue.main.async {
                self?.isAdReady = success
                print("Add loaded")
                if !success {
                    // If loading fails, try again after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self?.loadAd()
                    }
                }
            }
        }
    }
    
    func showAd(completion: @escaping (Bool) -> Void) {
        guard isAdReady else {
            completion(false)
            return
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            coordinator.showAd(from: rootViewController)
            isAdShown = true
            isAdReady = false  // Reset ad ready state
            completion(true)
            
            // Load the next ad immediately after showing one
            loadAd()
        } else {
            print("Unable to find root view controller")
            completion(false)
        }
    }
    
    func resetAdState() {
        isAdShown = false
        if !isAdReady {
            loadAd()
        }
    }
}
// The rest of the code (InterstitialAdCoordinator, AdViewControllerRepresentable, etc.) remains the same

class InterstitialAdCoordinator: NSObject, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    
    func loadAd(completion: @escaping (Bool) -> Void) {
        GADInterstitialAd.load(
            withAdUnitID: "ca-app-pub-4155055675967377/9037407522",
            request: GADRequest()
        ) { [weak self] ad, error in
            if let error = error {
                print("Failed to load ad with error: \(error.localizedDescription)")
                completion(false)
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
            completion(true)
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        interstitial = nil
        loadAd { _ in }
    }
    
    func showAd(from viewController: UIViewController) {
        guard let interstitial = interstitial else {
            return print("Ad Not ready")
        }
        
        interstitial.present(fromRootViewController: viewController)
    }
}

struct AdViewControllerRepresentable: UIViewControllerRepresentable {
    let viewController = UIViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
