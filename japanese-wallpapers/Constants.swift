//
//  Constants.swift
//  wallpaper-ai
//
//  Created by Julian Beck on 10.10.24.
//


import Foundation

enum Constants {
    enum API {
        static let categoriesLightURL = URL(string: "https://japanese-wallpaper-ai.beanvault.workers.dev/api/categories/light")!
        static let categoriesDarkURL = URL(string: "https://japanese-wallpaper-ai.beanvault.workers.dev/api/categories/dark")!
        static let fetchLatestWallpapersURL = URL(string: "https://japanese-wallpaper-ai.beanvault.workers.dev/api/latest")!
        static let imageBaseUrl = "https://japanese-wallpaper-ai.juli.sh"
    }
    
    enum UserDefaultsKeys {
        static let cachedCategoriesLight = "cachedCategoriesLight"
        static let cachedCategoriesDark = "cachedCategoriesDark"
    }
}
