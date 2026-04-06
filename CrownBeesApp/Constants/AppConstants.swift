import SwiftUI

struct AppConstants {
    // MARK: - Weather API
    // Replace with your own free key from https://openweathermap.org/api
    static let weatherAPIKey = "YOUR_OPENWEATHERMAP_API_KEY_HERE"
    static let weatherBaseURL = "https://api.openweathermap.org/data/2.5"
    
    // MARK: - UserDefaults Keys
    static let isLoggedInKey = "isLoggedIn"
    static let currentUserKey = "currentUser"
    static let releaseEntriesKey = "releaseEntries"
    static let harvestEntriesKey = "harvestEntries"
    static let pestEntriesKey = "pestEntries"
    
    // MARK: - Colors (programmatic use)
    static let honeyGold = Color(hex: "#F5A623")
    static let forestGreen = Color(hex: "#2D5F2D")
    static let warmBrown = Color(hex: "#8B6914")
    static let creamBackground = Color(hex: "#FFF8E7")
    static let darkText = Color(hex: "#333333")
    
    // MARK: - CrownBees URLs
    static let crownBeesURL = "https://crownbees.com"
    static let gettingStartedURL = "https://crownbees.com/pages/getting-started"
    static let productsURL = "https://crownbees.com/collections/all"
    static let faqURL = "https://crownbees.com/pages/faq"
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
