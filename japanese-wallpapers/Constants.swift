//
//  Constants.swift
//  wallpaper-ai
//
//  Created by Julian Beck on 10.10.24.
//


import Foundation

enum Constants {
    enum API {
        static let categoriesLight = URL(string: "https://wallpaper-ai.beanvault.workers.dev/api/categories")!
    }
    
    enum UserDefaultsKeys {
        static let cachedCategories = "cachedCategories"
    }
}
