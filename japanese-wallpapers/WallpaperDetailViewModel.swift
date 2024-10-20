I apologize for the confusion. If the GlobalAdManager is already set up as an environment object, we can modify our implementation to utilize it directly in the view and pass it to the view model. Let's update the WallpaperDetailView and WallpaperDetailViewModel to work with the GlobalAdManager as an environment object.


WallpaperDetailView with EnvironmentObject AdManager
Click to open code
Here are the key changes and improvements in this updated version:

Modified WallpaperDetailViewModel:
Removed adManager from the initializer.
Added a setup(adManager:) method to set the adManager after initialization.
Changed adManager to be a weak optional reference.
Updated WallpaperDetailView:
Added @EnvironmentObject private var adManager: GlobalAdManager.
Modified the initializer to only take imageURL as a parameter.
Added an onAppear modifier to set up the view model with the environment object adManager.
The WallpaperDetailView now passes the adManager to the view model in the onAppear modifier, ensuring that the view model has access to the correct adManager instance.
These changes ensure that:

The GlobalAdManager is accessed as an environment object, maintaining consistency with the rest of your app.
The view model still has access to the adManager for its operations.
The state is maintained correctly, even when the view reappears after an ad is shown.
Benefits of this approach:

Consistency with your app's existing architecture using environment objects.
Proper separation of concerns between the view and the view model.
Easier testing, as you can inject mock ad managers into the view model for unit tests.
To further improve the implementation, consider:

Implementing a way to handle potential race conditions if setup(adManager:) is called multiple times.
Adding more robust error handling for cases where the adManager might be nil.
Consider using Combine for more reactive state management, especially for the download progress.
Remember to test this implementation thoroughly, especially focusing on:

The behavior when ads are shown and dismissed.
The state of the download button in various scenarios (ad loading, ad ready, ad shown, download ready).
Error cases, such as when ad loading fails or when downloads fail.
This implementation should now work correctly with your existing GlobalAdManager as an environment object while maintaining the desired behavior for ad showing and image downloading.

Copy
Retry


Claude can make mistakes. Please double-check responses.



No file chosen


3.5 Sonnet
Tip:
Long chats cause you to reach your usage limits faster.
Start a new chat 

Updated WallpaperDetailView with Download Button and Progress Bar

import SwiftUI
import CachedAsyncImage
import UIKit

class WallpaperDetailViewModel: ObservableObject {
    @Published var downloadButtonState: DownloadButtonState = .loading
    @Published var isDownloading = false
    @Published var downloadProgress: Float = 0.0
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var showSuccessAlert = false
    
    let imageURL: URL
    weak var adManager: GlobalAdManager?
    
    init(imageURL: URL) {
        self.imageURL = imageURL
    }
    
    func setup(adManager: GlobalAdManager) {
        self.adManager = adManager
        loadAd()
    }
    
    func loadAd() {
        downloadButtonState = .loading
        adManager?.loadAd { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.downloadButtonState = .readyToPlayAd
                case .failure(let error):
                    print("Failed to load ad: \(error.localizedDescription)")
                    self?.downloadButtonState = .readyToDownload
                }
            }
        }
    }
    
    func handleDownloadButtonPress() {
        switch downloadButtonState {
        case .loading:
            // Do nothing, button should be disabled
            break
        case .readyToPlayAd:
            playAd()
        case .readyToDownload:
            downloadImage()
        }
    }
    
    private func playAd() {
        adManager?.showAd { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.downloadButtonState = .readyToDownload
                } else {
                    self?.alertMessage = "Failed to play ad. You can now download the image."
                    self?.showAlert = true
                    self?.downloadButtonState = .readyToDownload
                }
            }
        }
    }
    
    func downloadImage() {
        isDownloading = true
        
        URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.alertMessage = "Download failed: \(error.localizedDescription)"
                    self?.showAlert = true
                    self?.isDownloading = false
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    self?.alertMessage = "Failed to create image from downloaded data"
                    self?.showAlert = true
                    self?.isDownloading = false
                    return
                }
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self?.showSuccessAlert = true
                self?.isDownloading = false
                self?.adManager?.resetAdState()
                self?.loadAd() // Reload ad after successful download
            }
        }.resume()
        
        // Simulating download progress
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }
            if self.downloadProgress < 1.0 {
                self.downloadProgress += 0.05
            } else {
                timer.invalidate()
                self.downloadProgress = 0.0
            }
        }
    }
}