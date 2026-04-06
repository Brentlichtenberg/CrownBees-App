import Foundation
import Combine

class WeatherService: ObservableObject {
    @Published var currentWeather: WeatherResponse?
    @Published var forecast: ForecastResponse?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchWeather(zipCode: String) {
        guard AppConstants.weatherAPIKey != "YOUR_OPENWEATHERMAP_API_KEY_HERE" else {
            self.errorMessage = "Please replace the API key in AppConstants.swift with your own OpenWeatherMap API key."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let urlString = "\(AppConstants.weatherBaseURL)/weather?zip=\(zipCode),us&appid=\(AppConstants.weatherAPIKey)&units=imperial"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to load weather: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                self?.currentWeather = response
                self?.fetchForecast(zipCode: zipCode)
            })
            .store(in: &cancellables)
    }
    
    func fetchForecast(zipCode: String) {
        let urlString = "\(AppConstants.weatherBaseURL)/forecast?zip=\(zipCode),us&appid=\(AppConstants.weatherAPIKey)&units=imperial&cnt=40"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ForecastResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                self?.forecast = response
            })
            .store(in: &cancellables)
    }
    
    /// Returns an SF Symbol name based on OpenWeatherMap icon code
    func sfSymbol(for iconCode: String) -> String {
        switch iconCode {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snowflake"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.sun.fill"
        }
    }
}
