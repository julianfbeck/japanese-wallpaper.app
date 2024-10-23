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
    @Namespace var namespace


    var body: some View {
        let thumbnailURL = wallpaper.imageURL(isDownscaled: true)
        let fullSizeURL = wallpaper.imageURL(isDownscaled: false)
        
        NavigationLink {
            WallpaperDetailView(imageURL: fullSizeURL!, name: wallpaper.filename)
                .navigationTransition(.zoom(sourceID: thumbnailURL, in: namespace))
                .toolbarVisibility(.hidden, for: .navigationBar)
        }
        
        label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 5)
                
                CachedAsyncImage(url: thumbnailURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                

            }

        }
        .matchedTransitionSource(id: 1, in: namespace)
        .buttonStyle(PlainButtonStyle())
    }
}
