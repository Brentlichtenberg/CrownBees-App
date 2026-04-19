import Foundation
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

    @Published var currentWeather: AppWeather?
    @Published var dailyForecast: [AppDayWeather] = []
    @Published var locationName: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var locationAuthorized = false

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

    // MARK: - Manual search

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
                await self.fetchWeather(for: location.coordinate)
            }
        }
    }

    // MARK: - Open-Meteo fetch

    func fetchWeather(for coordinate: CLLocationCoordinate2D) async {
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        let urlStr = "https://api.open-meteo.com/v1/forecast"
            + "?latitude=\(lat)&longitude=\(lon)"
            + "&current=temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,weather_code,uv_index,is_day"
            + "&daily=weather_code,temperature_2m_max,temperature_2m_min"
            + "&temperature_unit=fahrenheit&wind_speed_unit=mph"
            + "&forecast_days=7&timezone=auto"

        guard let url = URL(string: urlStr) else {
            isLoading = false
            errorMessage = "Invalid request URL."
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)

            let c = decoded.current
            currentWeather = AppWeather(
                temperature: c.temperature2m,
                apparentTemperature: c.apparentTemperature,
                humidity: c.relativeHumidity2m,
                windSpeed: c.windSpeed10m,
                weatherCode: c.weatherCode,
                uvIndex: Int(c.uvIndex),
                isDay: c.isDay == 1
            )

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dailyForecast = zip(decoded.daily.time.indices, decoded.daily.time).compactMap { i, dateStr in
                guard let date = dateFormatter.date(from: dateStr) else { return nil }
                return AppDayWeather(
                    id: date,
                    date: date,
                    highTemp: decoded.daily.temperature2mMax[i],
                    lowTemp: decoded.daily.temperature2mMin[i],
                    weatherCode: decoded.daily.weatherCode[i]
                )
            }

            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Couldn't load weather data. Check your connection and try again."
        }
    }

    // MARK: - Bee activity

    var beeActivity: BeeActivity {
        guard let w = currentWeather else { return .unknown }
        if w.isRainy           { return .inactive }
        if w.temperature < 50  { return .inactive }
        if w.temperature < 55 || w.windSpeed > 15 { return .low }
        if w.temperature > 95  { return .low }
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
        let coordinate = location.coordinate
        Task { @MainActor in
            self.reverseGeocode(location)
            await self.fetchWeather(for: coordinate)
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

