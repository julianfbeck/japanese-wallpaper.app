//
//  WallpaperDetailView.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 16.10.24.
//


//
//  WallpaperDetailView.swift
//  wallpaper-ai
//
//  Created by Julian Beck on 10.10.24.
//


import SwiftUI
import CachedAsyncImage

struct WallpaperDetailView: View {
    let imageURL: URL
    @Environment(\.dismiss) private var dismiss
    
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
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
    }
}

struct WallpaperDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperDetailView(imageURL: URL(string: "https://wallpaper.apps.juli.sh/nature_00001_downscaled.jpg")!)
    }
}
