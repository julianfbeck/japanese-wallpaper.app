//
//  CategoryWallpaperView.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 16.10.24.
//


import SwiftUI
import CachedAsyncImage


struct CategoryWallpaperView: View {
    let category: Category
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(category.category.capitalized)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(1...category.count, id: \.self) { index in
                        let thumbnailURL = imageURL(for: category.category, index: index, isDownscaled: true)
                        let fullSizeURL = imageURL(for: category.category, index: index, isDownscaled: false)
                        NavigationLink(destination: WallpaperDetailView(imageURL: fullSizeURL)) {
                            CachedAsyncImage(url: thumbnailURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                case .failure:
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 200, height: 300)
                            .clipped()
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0)
                                .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                .blur(radius: phase.isIdentity ? 0 : 10)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func imageURL(for category: String, index: Int, isDownscaled: Bool) -> URL {
        let paddedIndex = String(format: "%05d", index)
        let suffix = isDownscaled ? "_downscaled" : ""
        return URL(string: "\(Constants.API.imageBaseUrl)/\(category)_\(paddedIndex)\(suffix).jpg")!
    }
}
// Preview provider for SwiftUI canvas
