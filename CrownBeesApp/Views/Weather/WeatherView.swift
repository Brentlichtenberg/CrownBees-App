import SwiftUI
import WeatherKit

struct WeatherView: View {
    @StateObject private var service = WeatherService()
    @State private var searchText = ""
    @State private var isSearching = false

    var body: some View {
        ScrollView {
            VStack(spacing: AppConstants.Spacing.md) {
                locationBar
                if service.isLoading {
                    loadingView
                } else if let error = service.errorMessage {
                    errorView(message: error)
                } else if let weather = service.currentWeather {
                    currentConditionsCard(weather)
                    beeActivityBanner
                    if !service.dailyForecast.isEmpty {
                        forecastCard
                    }
                } else {
                    promptView
                }
            }
            .padding(AppConstants.Spacing.md)
        }
        .background(AppConstants.beige.ignoresSafeArea())
        .navigationTitle("Weather")
    }

    // MARK: - Location Bar

    private var locationBar: some View {
        VStack(spacing: AppConstants.Spacing.sm) {
            HStack(spacing: AppConstants.Spacing.sm) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppConstants.darkGreen)
                TextField("City, state or zip code…", text: $searchText)
                    .submitLabel(.search)
                    .onSubmit { runSearch() }
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(AppConstants.Spacing.sm)
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppConstants.darkGreen.opacity(0.3), lineWidth: 1))

            HStack(spacing: AppConstants.Spacing.sm) {
                Button(action: runSearch) {
                    Label("Search", systemImage: "arrow.right.circle.fill")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(AppConstants.darkGreen)
                        .cornerRadius(10)
                }

                Button(action: { service.requestLocation() }) {
                    Label("Use My Location", systemImage: "location.fill")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(AppConstants.navyBlue)
                        .cornerRadius(10)
                }
            }
        }
    }

    // MARK: - Prompt

    private var promptView: some View {
        VStack(spacing: AppConstants.Spacing.md) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 60))
                .foregroundColor(AppConstants.orange)
            Text("Check the Weather for Your Bees")
                .font(.title3.weight(.semibold))
                .foregroundColor(AppConstants.darkGreen)
                .multilineTextAlignment(.center)
            Text("Search by city or zip, or tap \"Use My Location\" to get current conditions and a 7-day forecast.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppConstants.Spacing.xl)
    }

    // MARK: - Loading

    private var loadingView: some View {
        VStack(spacing: AppConstants.Spacing.md) {
            ProgressView().scaleEffect(1.5)
            Text("Loading weather…")
                .foregroundColor(.secondary)
        }
        .padding(AppConstants.Spacing.xl)
    }

    // MARK: - Error

    private func errorView(message: String) -> some View {
        VStack(spacing: AppConstants.Spacing.sm) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 36))
                .foregroundColor(AppConstants.orange)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(AppConstants.darkText)
            Button("Try Again") { service.requestLocation() }
                .font(.subheadline.weight(.medium))
                .foregroundColor(AppConstants.darkGreen)
        }
        .padding(AppConstants.Spacing.lg)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }

    // MARK: - Current Conditions

    private func currentConditionsCard(_ weather: CurrentWeather) -> some View {
        VStack(spacing: AppConstants.Spacing.md) {
            // Location + temp header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    if !service.locationName.isEmpty {
                        Text(service.locationName)
                            .font(.title2.weight(.bold))
                            .foregroundColor(AppConstants.darkGreen)
                    }
                    Text(weather.condition.description.capitalized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                HStack(alignment: .top, spacing: 2) {
                    Text("\(Int(weather.temperature.converted(to: .fahrenheit).value))")
                        .font(.system(size: 54, weight: .thin))
                    Text("°F")
                        .font(.title2)
                        .padding(.top, 8)
                }
                .foregroundColor(AppConstants.darkText)
            }

            // Weather icon row
            HStack {
                Image(systemName: weather.symbolName)
                    .font(.system(size: 44))
                    .symbolRenderingMode(.multicolor)
                Spacer()
            }

            Divider()

            // Detail row
            HStack(spacing: 0) {
                detailCell(
                    icon: "humidity.fill",
                    label: "Humidity",
                    value: "\(Int(weather.humidity * 100))%"
                )
                Spacer()
                detailCell(
                    icon: "wind",
                    label: "Wind",
                    value: "\(Int(weather.wind.speed.converted(to: .milesPerHour).value)) mph"
                )
                Spacer()
                detailCell(
                    icon: "thermometer.medium",
                    label: "Feels Like",
                    value: "\(Int(weather.apparentTemperature.converted(to: .fahrenheit).value))°F"
                )
                Spacer()
                detailCell(
                    icon: "sun.max.fill",
                    label: "UV Index",
                    value: "\(weather.uvIndex.value)"
                )
            }
        }
        .padding(AppConstants.Spacing.lg)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 3)
    }

    @ViewBuilder
    private func detailCell(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppConstants.darkGreen)
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(AppConstants.darkText)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Bee Activity Banner

    private var beeActivityBanner: some View {
        let activity = service.beeActivity
        return HStack(spacing: AppConstants.Spacing.sm) {
            Image(systemName: activity.icon)
                .font(.title3)
                .foregroundColor(activity.color)
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(activity.color)
                Text(activityTip)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(AppConstants.Spacing.md)
        .background(activity.color.opacity(0.1))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(activity.color.opacity(0.25), lineWidth: 1))
    }

    private var activityTip: String {
        guard let w = service.currentWeather else { return "" }
        let tempF = w.temperature.converted(to: .fahrenheit).value
        if tempF < 50 { return "Mason bees are inactive below 50°F." }
        if tempF < 55 { return "Activity picks up above 55°F." }
        let wind = w.wind.speed.converted(to: .milesPerHour).value
        if wind > 15 { return "High winds (>\(Int(wind)) mph) keep bees close to home." }
        if tempF > 95 { return "Very hot — bees may rest during peak afternoon heat." }
        return "Ideal foraging conditions for your mason bees."
    }

    // MARK: - Forecast

    private var forecastCard: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
            Text("7-Day Forecast")
                .font(.headline)
                .foregroundColor(AppConstants.darkGreen)

            ForEach(service.dailyForecast, id: \.date) { day in
                forecastRow(day)
                if day.date != service.dailyForecast.last?.date {
                    Divider()
                }
            }
        }
        .padding(AppConstants.Spacing.lg)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 3)
    }

    @ViewBuilder
    private func forecastRow(_ day: DayWeather) -> some View {
        HStack {
            Text(dayLabel(day.date))
                .font(.subheadline)
                .foregroundColor(AppConstants.darkText)
                .frame(width: 90, alignment: .leading)

            Image(systemName: day.symbolName)
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 22))
                .frame(width: 32)

            Spacer()

            HStack(spacing: 4) {
                Text("\(Int(day.lowTemperature.converted(to: .fahrenheit).value))°")
                    .foregroundColor(.secondary)
                Text("–")
                    .foregroundColor(.secondary)
                Text("\(Int(day.highTemperature.converted(to: .fahrenheit).value))°F")
                    .fontWeight(.medium)
                    .foregroundColor(AppConstants.darkText)
            }
            .font(.subheadline)
        }
        .padding(.vertical, 4)
    }

    // MARK: - Helpers

    private func runSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        service.search(query: searchText)
    }

    private func dayLabel(_ date: Date) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(date) { return "Today" }
        if cal.isDateInTomorrow(date) { return "Tomorrow" }
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE, MMM d"
        return fmt.string(from: date)
    }
}
