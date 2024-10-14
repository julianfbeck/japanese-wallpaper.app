class InterstitialAd: NSObject, GADFullScreenContentDelegate {
    var interstitial: GADInterstitialAd?
    
    override init() {
        super.init()
        loadAd()
    }
    
    func loadAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910",
                               request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    // ... rest of the code remains the same
}