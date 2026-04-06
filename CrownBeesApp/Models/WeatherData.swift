import Foundation

struct WeatherResponse: Codable {
    let main: MainWeather
    let weather: [WeatherCondition]
    let wind: Wind
    let name: String
}

struct MainWeather: Codable {
    let temp: Double
    let humidity: Int
    let feels_like: Double
}

struct WeatherCondition: Codable {
    let description: String
    let icon: String
    let main: String
}

struct Wind: Codable {
    let speed: Double
}

// MARK: - 5-Day Forecast
struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable, Identifiable {
    var id: String { dt_txt }
    let dt: TimeInterval
    let dt_txt: String
    let main: MainWeather
    let weather: [WeatherCondition]
}
