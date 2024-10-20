//
//  Constants.swift
//  wallpaper-ai
//
//  Created by Julian Beck on 10.10.24.
//


import Foundation

enum Constants {
    enum API {
        static let imageBaseUrl = "https://japanese-wallpaper-ai.juli.sh"
        static let baseAPIURL = "https://japanese-wallpaper-ai.beanvault.workers.dev/api"
        static let categoriesLightURL = URL(string: "https://japanese-wallpaper-ai.beanvault.workers.dev/api/categories/light")!
        static let categoriesDarkURL = URL(string: "https://japanese-wallpaper-ai.beanvault.workers.dev/api/categories/dark")!
        static let fetchLatestWallpapersURL = URL(string: "https://japanese-wallpaper-ai.beanvault.workers.dev/api/latest")!
        static let downloadIncrementURL = URL(string: "https://japanese-wallpaper-ai.beanvault.workers.dev/api/download")!
               static let topDownloadsURL = URL(string: "https://japanese-wallpaper-ai.beanvault.workers.dev/api/top-downloads")!
    }
    
    enum UserDefaultsKeys {
        static let cachedCategoriesLight = "cachedCategoriesLight"
        static let cachedCategoriesDark = "cachedCategoriesDark"
    }
}
