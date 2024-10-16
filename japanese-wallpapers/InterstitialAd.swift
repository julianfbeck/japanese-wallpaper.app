import SwiftUI
import GoogleMobileAds
import UIKit

class GlobalAdManager: ObservableObject {
    static let shared = GlobalAdManager()
    private let coordinator = InterstitialAdCoordinator()
    @Published var isAdReady = false
    
    private init() {
        loadAd()
    }
    
    func loadAd() {
        coordinator.loadAd { [weak self] success in
            DispatchQueue.main.async {
                self?.isAdReady = success
            }
        }
    }
    
    func showAd() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            coordinator.showAd(from: rootViewController)
        } else {
            print("Unable to find root view controller")
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
