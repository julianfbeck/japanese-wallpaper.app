# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Japanese Wallpapers is an iOS app built with SwiftUI that provides Japanese-themed AI-generated wallpapers. The app features categorized wallpapers, download functionality with ads, analytics tracking, and in-app purchases via RevenueCat.

## Build Commands

### iOS App Development
- **Build & Run**: Use Xcode to open `japanese-wallpapers.xcodeproj` and build/run the project
- **Target Device**: iPhone only (iOS 18.0+)
- **Code Signing**: Automatic with Development Team `VB9VC9U9AV`

### Backend API (Cloudflare Workers)
The `workers/` directory contains a separate Node.js backend:
- **Development**: `cd workers && npm install && npm run dev`
- **Deploy**: `cd workers && npm run deploy`

## Architecture

### iOS App Structure
- **App Entry**: `japanese_wallpapersApp.swift` - Main app with onboarding flow and analytics setup
- **Navigation**: Tab-based navigation with 5 tabs (All, New, Dark, Top, Settings)
- **Data Layer**: `WallpaperController.swift` - Handles API calls and local caching using UserDefaults
- **Models**: `Category` and `Wallpaper` structs with API URL generation
- **Views**:
  - `ContentView.swift` - Main tab view with category-based wallpaper browsing
  - `WallpaperDetailView.swift` - Full-screen wallpaper viewer with download functionality
  - `CategoryWallpaperView.swift` - Horizontal scrolling wallpaper grid for each category

### Key Dependencies
- **GoogleMobileAds**: Interstitial ads before wallpaper downloads
- **CachedAsyncImage**: Image loading and caching
- **RevenueCat**: In-app purchase management
- **Custom Plausible Analytics**: Privacy-focused analytics with device info tracking

### API Architecture
- **Base URL**: `https://japanese-wallpaper-ai.juli.sh` (images)
- **API URL**: `https://japanese-wallpaper-ai.beanvault.workers.dev/api` (data)
- **Endpoints**: Categories (light/dark), latest wallpapers, top downloads, download tracking
- **Image URLs**: Generated dynamically with downscaled thumbnails for performance

### Ad Integration
- Global ad manager (`GlobalAdManager`) handles interstitial ads
- Users must watch an ad before downloading wallpapers
- Ad loading happens proactively in background
- Download flow: Ready → Play Ad → Download Available

### Data Persistence
- UserDefaults for category caching and view counts
- Photos library integration for wallpaper downloads
- App review prompts triggered after specific view counts

## Development Notes

### Bundle Configuration
- Bundle ID: `com.julianbeck.japanese-wallpapers`
- Display Name: "Japan Art"
- Version: 1.2 (Build 2)
- Category: Graphics & Design

### Permissions
- Photo Library access for saving downloaded wallpapers
- Network access for API calls and analytics

### Testing
No specific test commands found - use Xcode's built-in testing framework.