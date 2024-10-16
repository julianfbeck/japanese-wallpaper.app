//
//  Category.swift
//  wallpaper-ai
//
//  Created by Julian Beck on 10.10.24.
//


import Foundation
import SwiftUI

struct Category: Codable, Identifiable {
    let category: String
    let count: Int
    let value: String
    let sorting: Int?
    var id: String { category }
}

struct Wallpaper: Codable, Identifiable {
    let id: String
    let filename: String
    let category: String
    let downloads: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case filename
        case category
        case downloads
    }
    
   
}
extension Wallpaper {
    func imageURL(isDownscaled: Bool) -> URL? {
        guard let baseURL = URL(string: Constants.API.imageBaseUrl) else {
            print("Error: Invalid base URL")
            return nil
        }
        
        let baseFilename = filename.replacingOccurrences(of: ".jpg", with: "")
        let suffix = isDownscaled ? "_downscaled.jpg" : ".jpg"
        return baseURL.appendingPathComponent(baseFilename + suffix)
    }
}

@Observable
class WallpaperController {
    var categoriesLight: [Category] = []
    var categoriesDark: [Category] = []
    var latestScreenshots: [Wallpaper] = []
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadCachedCategories()
        //        Task { await fetchCategoriesLight() }
        //        Task { await fetchCategoriesDark() }
        //        Task { await fetchLatestScreenshots() }
    }
    
    private func loadCachedCategories() {
        if let data = userDefaults.data(forKey: Constants.UserDefaultsKeys.cachedCategoriesLight),
           let cachedCategories = try? JSONDecoder().decode([Category].self, from: data) {
            categoriesLight = cachedCategories
        }
        
        if let data = userDefaults.data(forKey: Constants.UserDefaultsKeys.cachedCategoriesDark),
           let cachedCategories = try? JSONDecoder().decode([Category].self, from: data) {
            categoriesDark = cachedCategories
        }
    }
    
    private func saveCategoresToCache() {
        if let encodedData = try? JSONEncoder().encode(categoriesLight) {
            userDefaults.set(encodedData, forKey: Constants.UserDefaultsKeys.cachedCategoriesLight)
        }
        
        if let encodedData = try? JSONEncoder().encode(categoriesDark) {
            userDefaults.set(encodedData, forKey: Constants.UserDefaultsKeys.cachedCategoriesDark)
        }
        
    }
    
    @MainActor
    func fetchCategoriesLight() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: Constants.API.categoriesLightURL)
            let decodedCategories = try JSONDecoder().decode([Category].self, from: data)
            categoriesLight = decodedCategories
            saveCategoresToCache()
        } catch {
            print("Error fetching categories: \(error)")
        }
    }
    
    @MainActor
    func fetchCategoriesDark() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: Constants.API.categoriesDarkURL)
            let decodedCategories = try JSONDecoder().decode([Category].self, from: data)
            categoriesDark = decodedCategories
            saveCategoresToCache()
        } catch {
            print("Error fetching categories: \(error)")
        }
    }
    
    @MainActor
    func fetchLatestScreenshots() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: Constants.API.fetchLatestWallpapersURL)
            let decodedWallpapers = try JSONDecoder().decode([Wallpaper].self, from: data)
            latestScreenshots = decodedWallpapers
        } catch {
            print("Error fetching latest wallpapers: \(error)")
        }
    }
    
    
}
