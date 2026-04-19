import Foundation
import SwiftUI

// MARK: - Open-Meteo API Response

struct OpenMeteoResponse: Codable {
    let current: OpenMeteoCurrent
    let daily: OpenMeteoDaily
}

struct OpenMeteoCurrent: Codable {
    let temperature2m: Double
    let apparentTemperature: Double
    let relativeHumidity2m: Int
    let windSpeed10m: Double
    let weatherCode: Int
    let uvIndex: Double
    let isDay: Int

    enum CodingKeys: String, CodingKey {
        case temperature2m        = "temperature_2m"
        case apparentTemperature  = "apparent_temperature"
        case relativeHumidity2m   = "relative_humidity_2m"
        case windSpeed10m         = "wind_speed_10m"
        case weatherCode          = "weather_code"
        case uvIndex              = "uv_index"
        case isDay                = "is_day"
    }
}

struct OpenMeteoDaily: Codable {
    let time: [String]
    let weatherCode: [Int]
    let temperature2mMax: [Double]
    let temperature2mMin: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode       = "weather_code"
        case temperature2mMax  = "temperature_2m_max"
        case temperature2mMin  = "temperature_2m_min"
    }
}

// MARK: - Display Models

struct AppWeather {
    let temperature: Double       // °F
    let apparentTemperature: Double
    let humidity: Int             // percent
    let windSpeed: Double         // mph
    let weatherCode: Int
    let uvIndex: Int
    let isDay: Bool

    var sfSymbolName: String { WMOCode.sfSymbol(for: weatherCode, isDay: isDay) }
    var conditionLabel: String   { WMOCode.label(for: weatherCode) }
    var isRainy: Bool            { WMOCode.isRainy(weatherCode) }
}

struct AppDayWeather: Identifiable {
    let id: Date
    let date: Date
    let highTemp: Double
    let lowTemp: Double
    let weatherCode: Int

    var sfSymbolName: String { WMOCode.sfSymbol(for: weatherCode, isDay: true) }
}

// MARK: - WMO Weather Code helpers

enum WMOCode {
    static func label(for code: Int) -> String {
        switch code {
        case 0:        return "Clear Sky"
        case 1:        return "Mainly Clear"
        case 2:        return "Partly Cloudy"
        case 3:        return "Overcast"
        case 45, 48:   return "Foggy"
        case 51, 53:   return "Light Drizzle"
        case 55:       return "Dense Drizzle"
        case 61, 63:   return "Rain"
        case 65:       return "Heavy Rain"
        case 71, 73:   return "Light Snow"
        case 75:       return "Heavy Snow"
        case 77:       return "Snow Grains"
        case 80, 81:   return "Rain Showers"
        case 82:       return "Heavy Showers"
        case 85, 86:   return "Snow Showers"
        case 95:       return "Thunderstorm"
        case 96, 99:   return "Thunderstorm + Hail"
        default:       return "Partly Cloudy"
        }
    }

    static func sfSymbol(for code: Int, isDay: Bool) -> String {
        switch code {
        case 0:
            return isDay ? "sun.max.fill" : "moon.stars.fill"
        case 1:
            return isDay ? "sun.max.fill" : "moon.fill"
        case 2:
            return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case 3:
            return "cloud.fill"
        case 45, 48:
            return "cloud.fog.fill"
        case 51, 53, 55:
            return "cloud.drizzle.fill"
        case 61, 63:
            return isDay ? "cloud.sun.rain.fill" : "cloud.moon.rain.fill"
        case 65:
            return "cloud.heavyrain.fill"
        case 71, 73, 75, 77:
            return "snowflake"
        case 80, 81, 82:
            return "cloud.rain.fill"
        case 85, 86:
            return "cloud.snow.fill"
        case 95:
            return "cloud.bolt.fill"
        case 96, 99:
            return "cloud.bolt.rain.fill"
        default:
            return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        }
    }

    static func isRainy(_ code: Int) -> Bool {
        (51...65).contains(code) || (80...82).contains(code) || code == 95 || code == 96 || code == 99
    }
}
