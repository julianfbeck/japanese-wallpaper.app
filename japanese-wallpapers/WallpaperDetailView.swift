//
//  WallpaperDetailView.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 16.10.24.
//



import SwiftUI
import CachedAsyncImage
import UIKit


struct WallpaperDetailView: View {
    let imageURL: URL
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var adManager: GlobalAdManager
    @State private var isDownloading = false
    @State private var downloadProgress: Float = 0.0
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isAdShown = false
    
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
                        DownloadButton(action: initiateDownloadProcess, isEnabled: adManager.isAdReady || isAdShown)
                    }
                }
                .padding(.bottom, geometry.size.height / 6) // Position in lower third
            }
        }
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Download Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            adManager.loadAd()
        }
    }
    
    private func initiateDownloadProcess() {
        if isAdShown {
            downloadImage()
        } else if adManager.isAdReady {
            adManager.showAd()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Delay to ensure ad is shown
                isAdShown = true
                downloadImage()
            }
        } else {
            alertMessage = "Please wait for the ad to load before downloading."
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

struct CloseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.red)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 1)
        }
        .contentShape(Rectangle()) // Ensure the entire button area is tappable
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
