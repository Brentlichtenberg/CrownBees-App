import Foundation
import WeatherKit
import CoreLocation
import SwiftUI

// MARK: - Bee Activity

enum BeeActivity {
    case active, low, inactive, unknown

    var label: String {
        switch self {
        case .active:   return "Good bee activity expected"
        case .low:      return "Limited bee activity"
        case .inactive: return "Bees likely sheltering"
        case .unknown:  return "Activity unknown"
        }
    }

    var icon: String {
        switch self {
        case .active:   return "checkmark.circle.fill"
        case .low:      return "exclamationmark.circle.fill"
        case .inactive: return "xmark.circle.fill"
        case .unknown:  return "questionmark.circle"
        }
    }

    var color: Color {
        switch self {
        case .active:   return AppConstants.darkGreen
        case .low:      return AppConstants.orange
        case .inactive: return .red
        case .unknown:  return .gray
        }
    }
}

// MARK: - WeatherService

@MainActor
class WeatherService: NSObject, ObservableObject {

    // MARK: Published state

    @Published var currentWeather: CurrentWeather?
    @Published var dailyForecast: [DayWeather] = []
    @Published var locationName: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var locationAuthorized = false

    // MARK: Private

    private let kit = WeatherKit.WeatherService.shared
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        let status = locationManager.authorizationStatus
        locationAuthorized = (status == .authorizedWhenInUse || status == .authorizedAlways)
    }

    // MARK: - GPS

    func requestLocation() {
        isLoading = true
        errorMessage = nil
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            isLoading = false
            errorMessage = "Location access is denied. Enable it in Settings, or enter a city or zip code."
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    // MARK: - Manual search (city name or zip code)

    func search(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        geocoder.geocodeAddressString(trimmed) { [weak self] placemarks, error in
            guard let self else { return }
            Task { @MainActor in
                if error != nil || placemarks?.first == nil {
                    self.isLoading = false
                    self.errorMessage = "Location not found for \"\(trimmed)\". Try a city name, state, or zip code."
                    return
                }
                guard let placemark = placemarks!.first, let location = placemark.location else { return }
                self.locationName = Self.formatPlacemark(placemark)
                await self.fetchWeather(for: location)
            }
        }
    }

    // MARK: - WeatherKit fetch

    func fetchWeather(for location: CLLocation) async {
        do {
            let weather = try await kit.weather(
                for: location,
                including: .current, .daily(startDate: Date(), endDate: Date().addingTimeInterval(7 * 86400))
            )
            currentWeather = weather.0
            dailyForecast = Array(weather.1.forecast.prefix(7))
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Weather unavailable: \(error.localizedDescription)"
        }
    }

    // MARK: - Bee activity

    var beeActivity: BeeActivity {
        guard let w = currentWeather else { return .unknown }
        let tempF = w.temperature.converted(to: .fahrenheit).value
        let windMph = w.wind.speed.converted(to: .milesPerHour).value
        let rainyConditions: Set<WeatherCondition> = [
            .rain, .heavyRain, .drizzle, .thunderstorms,
            .isolatedThunderstorms, .scatteredThunderstorms
        ]
        if rainyConditions.contains(w.condition) { return .inactive }
        if tempF < 50 { return .inactive }
        if tempF < 55 || windMph > 15 { return .low }
        if tempF > 95 { return .low }
        return .active
    }

    // MARK: - Helpers

    private static func formatPlacemark(_ p: CLPlacemark) -> String {
        [p.locality, p.administrativeArea].compactMap { $0 }.joined(separator: ", ")
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherService: CLLocationManagerDelegate {

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        Task { @MainActor in
            self.reverseGeocode(location)
            await self.fetchWeather(for: location)
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            self.locationAuthorized = (status == .authorizedWhenInUse || status == .authorizedAlways)
            if self.locationAuthorized && self.isLoading {
                manager.requestLocation()
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.isLoading = false
            self.errorMessage = "Couldn't determine your location. Try entering a city or zip code."
        }
    }

    private func reverseGeocode(_ location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let placemark = placemarks?.first else { return }
            Task { @MainActor in
                self?.locationName = Self.formatPlacemark(placemark)
            }
        }
    }
}
