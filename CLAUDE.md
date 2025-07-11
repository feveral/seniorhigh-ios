# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a native iOS application called "升大學歷屆成績" (Senior High School Grade History) that helps high school students in Taiwan search for university admission scores. The app provides historical admission data for three types of entrance examinations: 學測 (Basic Test), 指考 (Designated Test), and 統測 (Unified Test).

## Development Commands

### Build and Run
- Build the project using Xcode: Open `seniorhigh.xcworkspace` (not the `.xcodeproj` file)
- Run on simulator or device through Xcode
- The project requires iOS 15.0 or later

### Dependencies
- Install CocoaPods dependencies: `pod install`
- Update dependencies: `pod update`

### Key Configuration
- Main configuration is in `seniorhigh/Config.swift`
- Database files are stored in `seniorhigh/` directory (`.db` files)
- Current active database: `grade_2025_0706.db`

## Architecture Overview

### Project Structure
```
seniorhigh/
├── model/          # Data models for grade records
├── database/       # Database connection and user data
├── services/       # API requests and download services
├── basic/          # Basic Test (學測) UI and logic
├── designated/     # Designated Test (指考) UI and logic
├── unify/          # Unified Test (統測) UI and logic
├── favorite/       # Favorite records functionality
└── utils/          # Utility classes and UI helpers
```

### Core Data Models
- `BasicGrade`: Model for Basic Test (學測) grades with subject-specific scores
- `DesignatedGrade`: Model for Designated Test (指考) grades with subject weights
- `UnifyGrade`: Model for Unified Test (統測) grades with department groups
- `Favorite`: Model for user's favorite grade records

### Database Architecture
- Uses SQLite.swift for database operations
- Main database: SQLite file with historical grade data
- User database: Separate SQLite file for user preferences and favorites
- Database access through `GradeDatabase` singleton

### UI Architecture
- Uses UIKit with Storyboards
- Tab-based navigation with `MainPageController` as root
- Each test type has its own storyboard and view controllers
- Material Design components for tabs (MaterialComponents/Tabs)
- SnapKit for programmatic Auto Layout

### Key Dependencies
- `SQLite.swift`: Database operations
- `Google-Mobile-Ads-SDK`: Advertisement integration
- `MaterialComponents/Tabs`: Tab navigation UI
- `SnapKit`: Auto Layout constraints

### Ad Integration
- Google Mobile Ads integrated throughout the app
- Banner ads and interstitial ads
- Test device IDs configured in `Config.swift`
- Ad management through `AdManager` utility class

## Important Notes

### Database Management
- Grade database is read-only and bundled with the app
- Database files are copied to documents directory on first launch
- Each year requires a new database file with updated grade data

### Search Functionality
- All three test types support keyword search
- Search matches both school names and department names
- Uses SQL LIKE patterns for fuzzy matching

### Grade Calculation
- Designated Test grades use weighted calculations based on subject weights
- Basic Test grades store individual subject scores
- Unified Test grades are grouped by department categories (20 different groups)

### Configuration Updates
- Update `Config.swift` when adding new academic years
- Database filename must match the actual .db file in the bundle
- API endpoints are configurable for remote data updates