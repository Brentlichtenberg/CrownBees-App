import SwiftUI

struct AppConstants {
    // MARK: - UserDefaults Keys
    static let isLoggedInKey = "isLoggedIn"
    static let currentUserKey = "currentUser"
    static let releaseEntriesKey = "releaseEntries"
    static let harvestEntriesKey = "harvestEntries"
    static let pestEntriesKey = "pestEntries"

    // MARK: - Brand Colours — Stitch "Botanical Architect" palette
    // Primary: Amber #865300 — core brand actions
    static let primary             = Color("BrandOrange")
    // Primary Container: Bright amber #E69100 — hero gradients, highlights
    static let primaryContainer    = Color("PrimaryContainer")
    // Secondary: Forest green #306944 — conservation, growth
    static let secondary           = Color("BrandDarkGreen")
    // Secondary Container: Mint #B0EEBF — soft accent fills
    static let secondaryContainer  = Color("SecondaryLightGreen")
    // Tertiary: Olive #4B662F — supporting nature palette
    static let tertiary            = Color(hex: "#4b662f")

    // MARK: - Surface Hierarchy (tonal layering — no border lines)
    // Base canvas: warm cream #FFF8F0
    static let surface                  = Color("SecondaryBeige")
    // Secondary content blocks: #FAF3EA
    static let surfaceContainerLow      = Color("SurfaceContainerLow")
    // High-contrast utility areas: #E8E2D9
    static let surfaceContainerHighest  = Color("SurfaceContainerHighest")
    // Card lift layer: white (light) / warm elevated dark (dark)
    static let surfaceContainerLowest   = Color("SurfaceContainerLowest")

    // MARK: - Content Colours
    // Near-black warm text (light) / warm white (dark) — adaptive
    static let onSurface = Color("OnSurface")
    // Muted secondary label — adaptive
    static let onSurfaceVariant = Color("OnSurfaceVariant")

    // MARK: - Semantic aliases (backwards-compatible names used across views)
    static let darkGreen  = secondary
    static let orange     = primary
    static let beige      = surface
    static let lightGreen = secondaryContainer
    static let darkText   = onSurface
    // navyBlue and lightBlue are retired; mapped to onSurface for contrast
    static let navyBlue   = onSurface
    static let lightBlue  = secondaryContainer

    // MARK: - Shadow
    // Ambient tint shadow — near-black warm (light) / warm white (dark)
    static let shadowColor = Color("OnSurface")

    // MARK: - Spacing (8-pt grid)
    enum Spacing {
        static let xs:  CGFloat =  4
        static let sm:  CGFloat =  8
        static let md:  CGFloat = 16
        static let lg:  CGFloat = 24
        static let xl:  CGFloat = 32
        static let xxl: CGFloat = 48
    }

    // MARK: - Corner Radius
    enum Radius {
        static let sm:  CGFloat =  8
        static let md:  CGFloat = 12
        static let lg:  CGFloat = 16
        static let xl:  CGFloat = 24  // CTA buttons
        static let full: CGFloat = 9999
    }

    // MARK: - CrownBees URLs
    static let crownBeesURL = "https://crownbees.com"
    static let gettingStartedURL = "https://crownbees.com/pages/rewilding"
    static let productsURL = "https://crownbees.com/collections/all"
    static let faqURL = "https://crownbees.com/pages/mason-bee-faq"
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
