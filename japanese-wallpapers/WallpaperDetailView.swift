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
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var isDownloading = false
    @State private var downloadProgress: Float = 0.0
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isAdShown = false
    @State private var adLoadFailed = false
    
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
                            CloseButton(action: dismiss)
                            DownloadButton(action: initiateDownloadProcess, isEnabled: networkMonitor.isConnected && (adManager.isAdReady || isAdShown || adLoadFailed))
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
        .onAppear {
            if networkMonitor.isConnected {
                loadAd()
            } else {
                alertMessage = "No internet connection. Please connect to the internet and try again."
                showAlert = true
            }
        }
    }
    
    private func loadAd() {
        adManager.loadAd { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Ad loaded successfully
                    break
                case .failure(let error):
                    print("Failed to load ad: \(error.localizedDescription)")
                    self.adLoadFailed = true
                }
            }
        }
    }
    
    private func initiateDownloadProcess() {
        guard networkMonitor.isConnected else {
            alertMessage = "No internet connection. Please connect to the internet and try again."
            showAlert = true
            return
        }
        
        if isAdShown || adLoadFailed {
            downloadImage()
        } else if adManager.isAdReady {
            adManager.showAd()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Delay to ensure ad is shown
                isAdShown = true
                downloadImage()
            }
        } else {
            alertMessage = "Preparing download. Please try again in a moment."
            showAlert = true
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
                self.alertMessage = "Image saved to Photos successfully!"
                self.showAlert = true
                self.isDownloading = false
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

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    @Published var isConnected = false

    init() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: workerQueue)
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

struct DownloadButton: View {
    let action: () -> Void
    let isEnabled: Bool
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.down.to.line")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(isEnabled ? Color.red : Color.gray)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .disabled(!isEnabled)
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
