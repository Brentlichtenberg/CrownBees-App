# 🐝 CrownBees App

A React Native mobile app for mason bee enthusiasts, built with TypeScript. Track your bee releases, harvests, and pest observations — plus get personalised weather forecasts and access CrownBees resources, all in one place.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Setup Instructions](#setup-instructions)
3. [Running the App](#running-the-app)
4. [Building an APK for Testing](#building-an-apk-for-testing)
5. [Weather API Key Setup](#weather-api-key-setup)
6. [Project Structure](#project-structure)
7. [Features](#features)

---

## Prerequisites

Before you begin, make sure you have the following installed:

| Tool | Version | Notes |
|------|---------|-------|
| **Node.js** | 18 or newer | [nodejs.org](https://nodejs.org) |
| **npm** | 9+ (bundled with Node 18) | |
| **React Native CLI** | latest | `npm install -g react-native-cli` |
| **Java JDK** | 17 | Required for Android builds |
| **Android Studio** | latest | For Android emulator & SDK |
| **Xcode** | 14+ | macOS only — for iOS builds |
| **CocoaPods** | latest | macOS only — `sudo gem install cocoapods` |

Make sure `ANDROID_HOME` and the Android SDK tools are on your `PATH`. See the [React Native environment setup guide](https://reactnative.dev/docs/environment-setup) for full details.

---

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/your-org/CrownBees-App.git
cd CrownBees-App
```

### 2. Install JavaScript dependencies

```bash
npm install
```

### 3. (iOS only) Install CocoaPods

```bash
cd ios
pod install
cd ..
```

---

## Running the App

### Start Metro bundler

In a dedicated terminal window:

```bash
npm start
```

### Run on Android emulator

Make sure an Android Virtual Device (AVD) is running in Android Studio, then:

```bash
npm run android
```

### Run on iOS simulator (macOS only)

```bash
npm run ios
```

---

## Building an APK for Testing

To build a debug APK you can install directly on an Android device:

```bash
# 1. Navigate to the android directory
cd android

# 2. Build the debug APK
./gradlew assembleDebug

# 3. The APK will be at:
#    android/app/build/outputs/apk/debug/app-debug.apk
```

To install the APK on a connected device or running emulator:

```bash
adb install app/build/outputs/apk/debug/app-debug.apk
```

### Build a release APK (unsigned, for testing only)

```bash
cd android
./gradlew assembleRelease
# APK: android/app/build/outputs/apk/release/app-release-unsigned.apk
```

> **Note:** A production-signed release requires a keystore file. See the [React Native signed APK guide](https://reactnative.dev/docs/signed-apk-android).

---

## Weather API Key Setup

The Weather screen requires a free API key from [OpenWeatherMap](https://openweathermap.org/api).

1. Sign up at [openweathermap.org](https://openweathermap.org) and generate a free API key.
2. Open `src/constants/index.ts`.
3. Replace the placeholder value:

```ts
// Before
export const WEATHER_API_KEY = 'YOUR_OPENWEATHERMAP_API_KEY_HERE';

// After
export const WEATHER_API_KEY = 'abc123yourrealkeyhere';
```

4. Restart Metro (`npm start -- --reset-cache`) for the change to take effect.

> The free tier supports up to 1,000 calls/day, which is more than enough for personal use.

---

## Project Structure

```
CrownBees-App/
├── App.tsx                          # Root component
├── src/
│   ├── components/
│   │   └── CustomDrawerContent.tsx  # Drawer sidebar with nav + logout
│   ├── constants/
│   │   └── index.ts                 # COLORS, SPACING, API keys, storage keys
│   ├── navigation/
│   │   └── AppNavigator.tsx         # Auth stack + Drawer navigator
│   ├── screens/
│   │   ├── LoginScreen.tsx
│   │   ├── RegisterScreen.tsx
│   │   ├── HomeScreen.tsx
│   │   ├── WeatherScreen.tsx
│   │   ├── JournalScreen.tsx        # Bee Release / Harvest / Pest Log tabs
│   │   └── ResourcesScreen.tsx
│   ├── services/
│   │   ├── authService.ts           # Register / login / logout logic
│   │   ├── storageService.ts        # AsyncStorage read/write helpers
│   │   └── weatherService.ts        # OpenWeatherMap API calls
│   ├── types/
│   │   └── index.ts                 # Shared TypeScript interfaces
│   └── utils/
│       └── index.ts                 # validateEmail, formatDate, generateId…
├── babel.config.js
├── metro.config.js
├── tsconfig.json
└── package.json
```

---

## Features

- 🔐 **Authentication** — Register with email, password, and zip code; login persisted locally via AsyncStorage.
- 🌤️ **Personalised Weather** — Current conditions + 5-day forecast based on your registered zip code (OpenWeatherMap API).
- 📓 **Bee Journal** — Three-tab journal: Bee Releases, Harvests, and Pest Log with full local persistence.
- 🔗 **Resources** — Quick-links to CrownBees.com guides, products, FAQ, and blog.
- 🎨 **Bee-themed UI** — Honey gold, forest green, and warm brown colour palette throughout.

---

## Contributing

Pull requests are welcome! Please open an issue first to discuss any significant changes.

## License

MIT
