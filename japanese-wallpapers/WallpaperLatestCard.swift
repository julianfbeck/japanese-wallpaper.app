//
//  WallpaperLatestCard.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 16.10.24.
//

import Foundation
import SwiftUI
import CachedAsyncImage

struct WallpaperLatestCard: View {
    let wallpaper: Wallpaper
    var namespace: Namespace.ID
    
    var body: some View {
        let thumbnailURL = wallpaper.imageURL(isDownscaled: true)
        let fullSizeURL = wallpaper.imageURL(isDownscaled: false)
        
        NavigationLink {
            WallpaperDetailView(imageURL: fullSizeURL!, name: wallpaper.filename)
                .navigationTransition(.zoom(sourceID: thumbnailURL, in: namespace))
                .toolbarVisibility(.hidden, for: .navigationBar)
        } label: {
            GeometryReader { geometry in
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(uiColor: .secondarySystemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 5)
                    
                    CachedAsyncImage(url: fullSizeURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .scaleEffect(1.5)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .contentShape(RoundedRectangle(cornerRadius: 24))
                        case .failure:
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .font(.system(size: 40))
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .matchedTransitionSource(id: 1, in: namespace)
        .buttonStyle(PlainButtonStyle())
    }
}
