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
    
    var id: String { category }
}

@Observable
class WallpaperController {
    var categories: [Category] = []
    private let userDefaults = UserDefaults.standard

    init() {
        loadCachedCategories()
        Task { await fetchCategories() }
    }
    
    private func loadCachedCategories() {
        if let data = userDefaults.data(forKey: Constants.UserDefaultsKeys.cachedCategories),
           let cachedCategories = try? JSONDecoder().decode([Category].self, from: data) {
            categories = cachedCategories
        }
    }
    
    private func saveCategoresToCache() {
        if let encodedData = try? JSONEncoder().encode(categories) {
            userDefaults.set(encodedData, forKey: Constants.UserDefaultsKeys.cachedCategories)
        }
    }
    
    @MainActor
    func fetchCategories() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: Constants.API.categoriesURL)
            let decodedCategories = try JSONDecoder().decode([Category].self, from: data)
            categories = decodedCategories
            saveCategoresToCache()
        } catch {
            print("Error fetching categories: \(error)")
        }
    }
}
