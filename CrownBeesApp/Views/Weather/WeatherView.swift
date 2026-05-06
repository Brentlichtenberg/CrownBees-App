import SwiftUI

struct WeatherView: View {
    @StateObject private var service = WeatherService()
    @State private var searchText = ""

    private var currentMonth: Int {
        Calendar.current.component(.month, from: Date())
    }

    private var advisory: BeeAdvisory {
        BeeSeasonalAdvisor.advisory(
            weather: service.currentWeather,
            forecast: service.dailyForecast,
            month: currentMonth
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppConstants.Spacing.md) {
                locationBar

                if service.isLoading {
                    loadingView
                } else if let error = service.errorMessage {
                    errorView(message: error)
                } else {
                    daveAdvisoryCard

                    if service.currentWeather != nil {
                        if advisory.releaseReadiness != nil, !advisory.warmForecastDays.isEmpty {
                            releaseWindowCard
                        }
                        currentConditionsCard
                        beeActivityBanner
                    }

                    if !service.dailyForecast.isEmpty {
                        forecastCard
                    }
                }
            }
            .padding(AppConstants.Spacing.md)
        }
        .background(
            LinearGradient(
                colors: [Color(hex: "#1a3d2a"), Color(hex: "#4a7c5a")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Weather")
    }

    // MARK: - Location Bar

    private var locationBar: some View {
        VStack(spacing: AppConstants.Spacing.sm) {
            HStack(spacing: AppConstants.Spacing.sm) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("City, state or zip code…", text: $searchText)
                    .submitLabel(.search)
                    .foregroundStyle(.primary)
                    .onSubmit { runSearch() }
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(AppConstants.Spacing.sm + 2)
            .glassEffect(in: .rect(cornerRadius: AppConstants.Radius.md))

            HStack(spacing: AppConstants.Spacing.sm) {
                Button(action: runSearch) {
                    Label("Search", systemImage: "arrow.right.circle.fill")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(AppConstants.primary)
                        .clipShape(Capsule())
                }
                Button(action: { service.requestLocation() }) {
                    Label("Use My Location", systemImage: "location.fill")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(AppConstants.secondary)
                        .clipShape(Capsule())
                }
            }
        }
    }

    // MARK: - Dave's Seasonal Advisory Card

    private var daveAdvisoryCard: some View {
        GlassEffectContainer {
            VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {

                HStack(spacing: AppConstants.Spacing.sm) {
                    ZStack {
                        Circle()
                            .fill(advisory.accentColor)
                            .frame(width: 44, height: 44)
                        Image(systemName: advisory.sfIcon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(advisory.phaseLabel.uppercased())
                            .font(.caption.weight(.bold))
                            .foregroundColor(advisory.accentColor)
                            .tracking(0.8)
                        Text("Dave's Bee Report")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }

                Divider().overlay(.primary.opacity(0.2))

                Text(advisory.headline)
                    .font(.title3.weight(.bold))
                    .foregroundColor(advisory.accentColor)

                Text(advisory.body)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)

                if !advisory.hasWeatherData {
                    HStack(spacing: 6) {
                        Image(systemName: "location.circle")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Search for your location above for personalised conditions.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 2)
                }

                Divider().overlay(.primary.opacity(0.2))

                HStack(spacing: 0) {
                    Image(systemName: "person.fill")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(" Dave Hunter · Crown Bees")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                    Image(systemName: "book.closed.fill")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(" The Mason Bee Revolution")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(AppConstants.Spacing.lg)
            .glassEffect(in: .rect(cornerRadius: 16))
        }
    }

    // MARK: - Release Window Card

    private var releaseWindowCard: some View {
        let readiness = advisory.releaseReadiness!
        let warmCount = advisory.warmForecastDays.filter { $0 }.count
        let isLeafCutter = advisory.phase == .summerLeafCutter
        let cardTitle = isLeafCutter ? "Leaf Cutter Release Window" : "Spring Release Window"

        return GlassEffectContainer {
            VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {

                HStack {
                    Image(systemName: readiness.icon)
                        .foregroundColor(readiness.color)
                    Text(cardTitle)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(readiness.label)
                        .font(.caption.weight(.bold))
                        .foregroundColor(readiness.color)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(readiness.color.opacity(0.2))
                        .cornerRadius(8)
                }

                HStack(spacing: 8) {
                    ForEach(Array(advisory.warmForecastDays.enumerated()), id: \.offset) { i, isWarm in
                        VStack(spacing: 4) {
                            Circle()
                                .fill(isWarm ? readiness.color : Color(.systemGray4))
                                .frame(width: 20, height: 20)
                                .overlay(
                                    isWarm ? Circle().stroke(readiness.color.opacity(0.4), lineWidth: 1.5) : nil
                                )
                            Text(forecastDayAbbrev(offset: i))
                                .font(.system(size: 9, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }

                HStack(spacing: 4) {
                    Image(systemName: warmCount >= 3 ? "checkmark.circle.fill" : "info.circle")
                        .font(.caption)
                        .foregroundColor(readiness.color)
                    Text("\(warmCount) of 7 forecast days above \(Int(advisory.tempThreshold))°F")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(BeeSeasonalAdvisor.releaseTip(
                    phase: advisory.phase,
                    readiness: advisory.releaseReadiness
                ))
                .font(.caption)
                .italic()
                .foregroundColor(.primary.opacity(0.8))
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding(AppConstants.Spacing.lg)
            .glassEffect(in: .rect(cornerRadius: 16))
        }
    }

    // MARK: - Current Conditions

    @ViewBuilder
    private var currentConditionsCard: some View {
        if let weather = service.currentWeather {
            GlassEffectContainer {
                VStack(spacing: AppConstants.Spacing.md) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            if !service.locationName.isEmpty {
                                Text(service.locationName)
                                    .font(.title2.weight(.bold))
                                    .foregroundColor(.primary)
                            }
                            Text(weather.conditionLabel)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        HStack(alignment: .top, spacing: 2) {
                            Text("\(Int(weather.temperature))")
                                .font(.system(size: 54, weight: .thin))
                            Text("°F")
                                .font(.title2)
                                .padding(.top, 8)
                        }
                        .foregroundColor(.primary)
                            .font(.system(size: 48))
                            .symbolRenderingMode(.multicolor)
                        Spacer()
                    }

                    Divider().overlay(.primary.opacity(0.2))

                    HStack(spacing: 0) {
                        detailCell(icon: "humidity.fill",       label: "Humidity",   value: "\(weather.humidity)%")
                        Spacer()
                        detailCell(icon: "wind",                label: "Wind",       value: "\(Int(weather.windSpeed)) mph")
                        Spacer()
                        detailCell(icon: "thermometer.medium",  label: "Feels Like", value: "\(Int(weather.apparentTemperature))°F")
                        Spacer()
                        detailCell(icon: "sun.max.fill",        label: "UV Index",   value: "\(weather.uvIndex)")
                    }
                }
                .padding(AppConstants.Spacing.lg)
                .glassEffect(in: .rect(cornerRadius: 16))
            }
        }
    }

    private func detailCell(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
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
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(AppConstants.Spacing.md)
        .glassEffect(in: .rect(cornerRadius: 12))
    }

    private var activityTip: String {
        guard let w = service.currentWeather else { return "" }
        if w.isRainy        { return "Bees shelter during rain — they seal cell mud with their mandibles and wait." }
        if w.temperature < 50 { return "Solitary bees are inactive below 50°F. They won't forage until the air warms up." }
        if w.temperature < 55 { return "Activity picks up above 55°F, when fruit tree bloom begins." }
        if w.windSpeed > 20   { return "High winds over 20 mph make navigation difficult. Bees stay close to home." }
        if w.windSpeed > 15   { return "Breezy conditions (\(Int(w.windSpeed)) mph) reduce foraging range." }
        if w.temperature > 95 { return "Very hot afternoon — bees may rest during peak heat and resume in the evening." }
        if w.uvIndex >= 8     { return "High UV and good warmth — near-perfect foraging conditions." }
        return "Ideal foraging conditions. Your solitary bees are working their 8–30 trips per cell."
    }

    private var forecastCard: some View {
        GlassEffectContainer {
            VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
                HStack {
                    Text("7-Day Forecast")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Text("Bee Activity")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                ForEach(service.dailyForecast, id: \.date) { day in
                    forecastRow(day)
                    if day.date != service.dailyForecast.last?.date {
                        Divider().overlay(.primary.opacity(0.2))
                    }
                }
            }
            .padding(AppConstants.Spacing.lg)
            .glassEffect(in: .rect(cornerRadius: 16))
        }
    }

    private func forecastRow(_ day: AppDayWeather) -> some View {
        let beeAct = BeeSeasonalAdvisor.dailyBeeActivity(
            high: day.highTemp,
            weatherCode: day.weatherCode
        )
        return HStack(spacing: AppConstants.Spacing.sm) {
            Text(dayLabel(day.date))
                .font(.subheadline)
                .foregroundColor(.primary)
                .frame(width: 85, alignment: .leading)

            Image(systemName: day.sfSymbolName)
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 22))
                .frame(width: 28)

            Spacer()

            HStack(spacing: 4) {
                Text("\(Int(day.lowTemp))°")
                    .foregroundColor(.secondary)
                Text("–")
                    .foregroundColor(.secondary)
                Text("\(Int(day.highTemp))°F")
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .font(.subheadline)

            Image(systemName: beeAct.icon)
                .font(.system(size: 14))
                .foregroundColor(beeAct.color)
                .frame(width: 20)
        }
        .padding(.vertical, 4)
    }

    // MARK: - Loading / Error

    private var loadingView: some View {
        VStack(spacing: AppConstants.Spacing.md) {
            ProgressView().scaleEffect(1.5)
            Text("Loading weather…")
                .foregroundColor(.secondary)
        }
        .padding(AppConstants.Spacing.xl)
    }

    private func errorView(message: String) -> some View {
        GlassEffectContainer {
            VStack(spacing: AppConstants.Spacing.sm) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(AppConstants.orange)
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                Button("Try Again") { service.requestLocation() }
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(Color(hex: "#865300"))
            }
            .padding(AppConstants.Spacing.lg)
            .frame(maxWidth: .infinity)
            .glassEffect(in: .rect(cornerRadius: 14))
        }
    }

    // MARK: - Helpers

    private func runSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        service.search(query: searchText)
    }

    private func dayLabel(_ date: Date) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(date)    { return "Today" }
        if cal.isDateInTomorrow(date) { return "Tomorrow" }
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE, MMM d"
        return fmt.string(from: date)
    }

    private func forecastDayAbbrev(offset: Int) -> String {
        guard offset < service.dailyForecast.count else { return "" }
        let cal = Calendar.current
        let date = service.dailyForecast[offset].date
        if cal.isDateInToday(date) { return "Now" }
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE"
        return String(fmt.string(from: date).prefix(2))
    }
}
