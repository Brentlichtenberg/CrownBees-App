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
    
    // MARK: - Brand Colours — Primary
    static let darkGreen  = Color("BrandDarkGreen")    // #004322
    static let orange     = Color("BrandOrange")        // #FF8F05

    // MARK: - Brand Colours — Secondary
    static let lightBlue  = Color("SecondaryLightBlue") // #7DC9F0
    static let navyBlue   = Color("SecondaryBlue")      // #003166
    static let beige      = Color("SecondaryBeige")     // #FBF4EB
    static let lightGreen = Color("SecondaryLightGreen") // #BDDD99

    // MARK: - Semantic aliases (adaptive)
    static let darkText   = Color(.label)

    // MARK: - Spacing
    enum Spacing {
        static let xs:  CGFloat =  4
        static let sm:  CGFloat =  8
        static let md:  CGFloat = 16
        static let lg:  CGFloat = 24
        static let xl:  CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
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
