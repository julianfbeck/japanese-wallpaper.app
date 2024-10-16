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
            Text(category.value)
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
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func imageURL(for category: String, index: Int, isDownscaled: Bool) -> URL {
           let paddedIndex = String(format: "%05d", index)
           let suffix = isDownscaled ? "_downscaled" : ""
           return URL(string: "https://wallpaper.apps.juli.sh/\(category)_\(paddedIndex)\(suffix).jpg")!
       }
}

// Preview provider for SwiftUI canvas
struct CategoryWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CategoryWallpaperView(category: Category(category: "nature", count: 2, value: "Nature Landscapes"))
        }
    }
}
