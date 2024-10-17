//
//  WallpaperDetailView.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 16.10.24.
//

import SwiftUI
import CachedAsyncImage
import UIKit
import Network



struct WallpaperDetailView: View {
    let imageURL: URL
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var adManager: GlobalAdManager
    @State private var isDownloading = false
    @State private var downloadProgress: Float = 0.0
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showSuccessAlert = false
    @State private var downloadButtonState: DownloadButtonState = .loading
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                CachedAsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    if isDownloading {
                        DownloadProgressView(progress: $downloadProgress)
                            .frame(height: 60)
                            .padding(.horizontal)
                    } else {
                        HStack(spacing: 20) {
                            CloseButton(action: {dismiss()})
                            DownloadButton(action: handleDownloadButtonPress, state: downloadButtonState)
                        }
                    }
                }
                .padding(.bottom, geometry.size.height / 6) // Position in lower third
            }
        }
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Image saved to Photos successfully!")
        }
        .onAppear {
            loadAd()
        }
    }
    
    private func loadAd() {
        downloadButtonState = .loading
        adManager.loadAd { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.downloadButtonState = .readyToPlayAd
                case .failure(let error):
                    print("Failed to load ad: \(error.localizedDescription)")
                    self.downloadButtonState = .readyToDownload
                }
            }
        }
    }
    
    private func handleDownloadButtonPress() {
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
        adManager.showAd { success in
            DispatchQueue.main.async {
                if success {
                    self.downloadButtonState = .readyToDownload
                } else {
                    self.alertMessage = "Failed to play ad. You can now download the image."
                    self.showAlert = true
                    self.downloadButtonState = .readyToDownload
                }
            }
        }
    }
    
    private func downloadImage() {
        isDownloading = true
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.alertMessage = "Download failed: \(error.localizedDescription)"
                    self.showAlert = true
                    self.isDownloading = false
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    self.alertMessage = "Failed to create image from downloaded data"
                    self.showAlert = true
                    self.isDownloading = false
                    return
                }
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self.showSuccessAlert = true
                self.isDownloading = false
                self.adManager.resetAdState()
                self.loadAd() // Reload ad after successful download
            }
        }.resume()
        
        // Simulating download progress
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if downloadProgress < 1.0 {
                downloadProgress += 0.05
            } else {
                timer.invalidate()
                downloadProgress = 0.0
            }
        }
    }
}

enum DownloadButtonState {
    case loading
    case readyToPlayAd
    case readyToDownload
}

struct DownloadButton: View {
    let action: () -> Void
    let state: DownloadButtonState
    
    var body: some View {
        Button(action: action) {
            Image(systemName: buttonIcon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(buttonColor)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .disabled(state == .loading)
    }
    
    private var buttonColor: Color {
        switch state {
        case .loading:
            return .gray
        case .readyToPlayAd:
            return .red
        case .readyToDownload:
            return .green
        }
    }
    
    private var buttonIcon: String {
        switch state {
        case .loading:
            return "hourglass"
        case .readyToPlayAd:
            return "play.fill"
        case .readyToDownload:
            return "arrow.down.to.line"
        }
    }
}

struct CloseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
    }
}

struct DownloadProgressView: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .cornerRadius(15)
            
            VStack(spacing: 10) {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .red))
                    .frame(height: 8)
                
                Text("\(Int(progress * 100))%")
                    .foregroundColor(.white)
                    .font(.caption)
            }
            .padding()
        }
    }
}

struct WallpaperDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperDetailView(imageURL: URL(string: "https://wallpaper.apps.juli.sh/nature_00001_downscaled.jpg")!)
            .environmentObject(GlobalAdManager.shared)
    }
}
