import SwiftUI
import GoogleMobileAds

// MARK: - Helper to present Interstitial Ad
private struct AdViewControllerRepresentable: UIViewControllerRepresentable {
    let viewController = UIViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

private class InterstitialAdCoordinator: NSObject, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    
    func loadAd() {
        GADInterstitialAd.load(
            withAdUnitID: "ca-app-pub-4155055675967377/9037407522",
            request: GADRequest()
        ) { ad, _ in
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        interstitial = nil
    }
    
    func showAd(from viewController: UIViewController) {
        guard let interstitial = interstitial else {
            return print("Ad Not ready")
        }
        
        interstitial.present(fromRootViewController: viewController)
    }
}

struct ContentView: View {
    private let coordinator = InterstitialAdCoordinator()
    private let adViewControllerRepresentable = AdViewControllerRepresentable()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Interstitial Ad Example")
                .font(.largeTitle)
                .background(adViewControllerRepresentable)
            
            Spacer()
            
            Button("Show Ad") {
                coordinator.showAd(from: adViewControllerRepresentable.viewController)
            }
            .font(.title2)
            
            Spacer()
        }
        .onAppear {
            coordinator.loadAd()
        }
    }
}
