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
    @StateObject private var viewModel: WallpaperDetailViewModel
    @EnvironmentObject private var adManager: GlobalAdManager
    @Environment(\.dismiss) private var dismiss
    
    init(imageURL: URL) {
        _viewModel = StateObject(wrappedValue: WallpaperDetailViewModel(imageURL: imageURL))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                CachedAsyncImage(url: viewModel.imageURL) { phase in
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
                    
                    if viewModel.isDownloading {
                        DownloadProgressView(progress: $viewModel.downloadProgress)
                            .frame(height: 60)
                            .padding(.horizontal)
                    } else {
                        VStack(spacing: 10) {
                            if viewModel.downloadButtonState == .readyToPlayAd {
                                Text("Watch an Ad to Download")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.red)
                                    .cornerRadius(20)
                            }
                            HStack(spacing: 20) {
                                CloseButton(action: {dismiss()})
                                DownloadButton(action: viewModel.handleDownloadButtonPress, state: viewModel.downloadButtonState)
                            }
                        }
                    }
                }
                .padding(.bottom, geometry.size.height / 6) // Position in lower third
            }
        }
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Status"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .alert("Success", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Image saved to Photos successfully!")
        }
        .onAppear {
            viewModel.setup(adManager: adManager)
        }
    }
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
