# CrownBees iOS App

A proof-of-concept SwiftUI iOS companion app for [CrownBees](https://crownbees.com) — the mason bee experts.

---

## 📱 Features

| Screen | Description |
|---|---|
| **Login / Register** | Local account stored in `UserDefaults`. Email validation, password confirmation, and 5-digit zip code required at sign-up. |
| **Home** | Welcome screen with hero image placeholder and feature highlight cards. |
| **Personalised Weather** | Current conditions + 5-day forecast powered by OpenWeatherMap, keyed to the user's zip code. |
| **Journal** | Three-tab beekeeping log — **Release**, **Harvest**, and **Pest** observations — persisted locally via `UserDefaults`. |
| **Resources** | In-app Safari links to the CrownBees website, Getting Started guide, Products catalogue, and FAQ. |
| **Side Drawer** | Hamburger menu slides in from the trailing edge with navigation and log-out. |

---

## 🗂 Project Structure

```
CrownBeesApp/
├── CrownBeesApp.xcodeproj/
│   └── project.pbxproj
└── CrownBeesApp/
    ├── CrownBeesAppApp.swift       # @main entry point
    ├── ContentView.swift           # Auth gate (login vs. main app)
    ├── Models/
    │   ├── User.swift
    │   ├── JournalEntry.swift      # ReleaseEntry, HarvestEntry, PestEntry
    │   └── WeatherData.swift
    ├── Views/
    │   ├── Auth/
    │   │   ├── LoginView.swift
    │   │   └── RegisterView.swift
    │   ├── Home/
    │   │   └── HomeView.swift
    │   ├── Weather/
    │   │   └── WeatherView.swift
    │   ├── Journal/
    │   │   ├── JournalView.swift
    │   │   ├── ReleaseLogView.swift
    │   │   ├── HarvestLogView.swift
    │   │   └── PestLogView.swift
    │   ├── Resources/
    │   │   └── ResourcesView.swift
    │   └── Components/
    │       ├── MainAppView.swift   # Root shell with drawer
    │       ├── SideMenuView.swift
    │       └── MenuButton.swift
    ├── Services/
    │   ├── AuthService.swift       # ObservableObject, UserDefaults auth
    │   ├── WeatherService.swift    # Combine + URLSession weather fetching
    │   └── StorageService.swift    # Journal CRUD via UserDefaults
    ├── Constants/
    │   └── AppConstants.swift      # Colors, API key, URL constants
    ├── Assets.xcassets/
    └── Info.plist
```

---

## 🚀 Getting Started

### Requirements
- **Xcode 15+**
- **iOS 16.0+** deployment target
- Swift 5

### Setup

1. **Clone the repository**
   ```bash
   git clone <repo-url>
   cd CrownBees-App
   ```

2. **Open in Xcode**
   ```bash
   open CrownBeesApp.xcodeproj
   ```

3. **Add your OpenWeatherMap API key**

   Open `CrownBeesApp/Constants/AppConstants.swift` and replace the placeholder:
   ```swift
   static let weatherAPIKey = "YOUR_OPENWEATHERMAP_API_KEY_HERE"
   ```
   Get a free key at [https://openweathermap.org/api](https://openweathermap.org/api).

4. **Select a simulator or device** and press **⌘R** to build and run.

> **Note:** The weather screen shows an instructional error until a valid API key is provided. All other features (auth, journal, resources) work without it.

---

## 🎨 Design Tokens

| Token | Hex | Usage |
|---|---|---|
| `honeyGold` | `#F5A623` | Accents, icons, highlights |
| `forestGreen` | `#2D5F2D` | Primary brand color, buttons |
| `warmBrown` | `#8B6914` | Secondary actions, harvest theme |
| `creamBackground` | `#FFF8E7` | App background |
| `darkText` | `#333333` | Body text |

---

## 🔐 Authentication

Authentication is **local-only** (no backend). Credentials are stored in `UserDefaults`. This is intentional for a proof-of-concept — replace `AuthService` with a real backend (Firebase, Supabase, etc.) for production.

---

## 📦 Dependencies

None. The app uses only Apple frameworks:
- **SwiftUI** — UI
- **Combine** — reactive data flow
- **SafariServices** — in-app web browsing
- **Foundation** — networking, encoding/decoding

---

## 📝 Roadmap (Proof of Concept → Production)

- [ ] Replace local auth with a real authentication backend
- [ ] Add hero/banner images from CrownBees brand assets
- [ ] Push notifications for seasonal reminders
- [ ] iCloud sync for journal entries
- [ ] Bee lifecycle calendar and activity tracker
- [ ] App Store submission (bundle ID, provisioning, icons)

---

## 📄 License

This project is a proof-of-concept created for CrownBees. All CrownBees branding, URLs, and content belong to [Crown Bees, Inc.](https://crownbees.com)