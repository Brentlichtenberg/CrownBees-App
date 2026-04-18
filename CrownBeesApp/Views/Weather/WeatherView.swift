import SwiftUI

struct WeatherView: View {
    @StateObject private var weatherService = WeatherService()
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Zip code note
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(AppConstants.darkGreen)
                    Text("Weather data is based on your registered zip code.")
                        .font(.caption)
                        .foregroundColor(AppConstants.darkText)
                    Spacer()
                }
                .padding(12)
                .background(AppConstants.orange.opacity(0.2))
                .cornerRadius(10)
                
                if weatherService.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading weather...")
                            .foregroundColor(AppConstants.darkText)
                    }
                    .padding(40)
                    
                } else if let error = weatherService.errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(AppConstants.darkText)
                        Button("Try Again") {
                            if let zip = authService.currentUser?.zipCode {
                                weatherService.fetchWeather(zipCode: zip)
                            }
                        }
                        .foregroundColor(AppConstants.darkGreen)
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    
                } else if let weather = weatherService.currentWeather {
                    // Current Weather Card
                    VStack(spacing: 16) {
                        HStack {
                            Text(weather.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(AppConstants.darkGreen)
                            Spacer()
                            Text("\(Int(weather.main.temp))°F")
                                .font(.system(size: 44, weight: .thin))
                                .foregroundColor(AppConstants.darkText)
                        }
                        
                        if let condition = weather.weather.first {
                            HStack {
                                Image(systemName: weatherService.sfSymbol(for: condition.icon))
                                    .font(.system(size: 40))
                                    .foregroundColor(AppConstants.orange)
                                Text(condition.description.capitalized)
                                    .font(.title3)
                                    .foregroundColor(AppConstants.darkText)
                                Spacer()
                            }
                        }
                        
                        Divider()
                        
                        HStack(spacing: 0) {
                            weatherDetail(
                                icon: "humidity.fill",
                                label: "Humidity",
                                value: "\(weather.main.humidity)%"
                            )
                            Spacer()
                            weatherDetail(
                                icon: "wind",
                                label: "Wind",
                                value: "\(String(format: "%.1f", weather.wind.speed)) mph"
                            )
                            Spacer()
                            weatherDetail(
                                icon: "thermometer.medium",
                                label: "Feels Like",
                                value: "\(Int(weather.main.feels_like))°F"
                            )
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 3)
                    
                    // 5-Day Forecast
                    if let forecast = weatherService.forecast {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("5-Day Forecast")
                                .font(.headline)
                                .foregroundColor(AppConstants.darkGreen)
                            
                            let dailyForecasts = groupForecastByDay(forecast.list)
                            ForEach(dailyForecasts.prefix(5), id: \.0) { day, items in
                                if let item = items.first {
                                    forecastRow(day: day, item: item)
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 3)
                    }
                }
            }
            .padding(16)
        }
        .background(AppConstants.beige)
        .navigationTitle("Weather")
        .onAppear {
            if let zip = authService.currentUser?.zipCode {
                weatherService.fetchWeather(zipCode: zip)
            }
        }
    }
    
    @ViewBuilder
    private func weatherDetail(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(AppConstants.darkGreen)
            Text(value)
                .font(.headline)
                .foregroundColor(AppConstants.darkText)
            Text(label)
                .font(.caption)
                .foregroundColor(AppConstants.darkText.opacity(0.6))
        }
    }
    
    @ViewBuilder
    private func forecastRow(day: String, item: ForecastItem) -> some View {
        HStack {
            Text(day)
                .font(.body)
                .foregroundColor(AppConstants.darkText)
                .frame(width: 100, alignment: .leading)
            
            if let cond = item.weather.first {
                Image(systemName: weatherService.sfSymbol(for: cond.icon))
                    .foregroundColor(AppConstants.orange)
            }
            
            Spacer()
            
            Text("\(Int(item.main.temp))°F")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(AppConstants.darkText)
        }
        .padding(.vertical, 4)
        Divider()
    }
    
    private func groupForecastByDay(_ items: [ForecastItem]) -> [(String, [ForecastItem])] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE, MMM d"
        
        var dict: [(String, [ForecastItem])] = []
        var seen: [String] = []
        
        for item in items {
            if let date = formatter.date(from: item.dt_txt) {
                let dayStr = dayFormatter.string(from: date)
                if !seen.contains(dayStr) {
                    seen.append(dayStr)
                    dict.append((dayStr, items.filter {
                        if let d = formatter.date(from: $0.dt_txt) {
                            return dayFormatter.string(from: d) == dayStr
                        }
                        return false
                    }))
                }
            }
        }
        return dict
    }
}
