//
//  WallpaperDetailViewModel.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 17.10.24.
//


import SwiftUI
import CachedAsyncImage
import UIKit
import Combine

enum DownloadButtonState {
    case loading
    case readyToPlayAd
    case readyToDownload
}


class WallpaperDetailViewModel: ObservableObject {
    @Published var downloadButtonState: DownloadButtonState = .loading
    @Published var isDownloading = false
    @Published var downloadProgress: Float = 0.0
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var showSuccessAlert = false
    @Published var canDownload = false
    
    let imageURL: URL
    weak var adManager: GlobalAdManager?
    private var cancellables = Set<AnyCancellable>()
    
    init(imageURL: URL) {
        self.imageURL = imageURL
    }
    
    func setup(adManager: GlobalAdManager) {
        self.adManager = adManager
        
        adManager.$isAdReady
            .sink { [weak self] isReady in
                self?.updateButtonState()
            }
            .store(in: &cancellables)
        
        updateButtonState()
    }
    
    func updateButtonState() {
        if canDownload {
            downloadButtonState = .readyToDownload
        } else if let adManager = adManager, adManager.isAdReady {
            downloadButtonState = .readyToPlayAd
        } else {
            downloadButtonState = .loading
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
        downloadButtonState = .loading
        adManager?.showAd { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.canDownload = true
                    self?.updateButtonState()
                } else {
                    self?.alertMessage = "Failed to play ad. Please try again."
                    self?.showAlert = true
                    self?.updateButtonState()
                }
            }
        }
    }
    
    func downloadImage() {
        guard canDownload else {
            alertMessage = "Please watch an ad before downloading."
            showAlert = true
            return
        }
        
        isDownloading = true
        downloadButtonState = .loading
        
        URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.alertMessage = "Download failed: \(error.localizedDescription)"
                    self?.showAlert = true
                    self?.isDownloading = false
                    self?.updateButtonState()
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    self?.alertMessage = "Failed to create image from downloaded data"
                    self?.showAlert = true
                    self?.isDownloading = false
                    self?.updateButtonState()
                    return
                }
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self?.showSuccessAlert = true
                self?.isDownloading = false
                self?.canDownload = false  // Reset the download permission
                self?.adManager?.resetAdState()
                self?.updateButtonState()
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
