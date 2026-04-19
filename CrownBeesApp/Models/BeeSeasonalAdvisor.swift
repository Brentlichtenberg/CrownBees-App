import Foundation
import SwiftUI

// MARK: - Season Phase

/// Represents where we are in the mason bee seasonal calendar.
/// Phase is determined by calendar month + current/forecast temperatures.
enum BeeSeasonPhase: Equatable {
    case winterStorage          // Dec–Feb: cocoons in fridge, nothing to do
    case springWaiting          // Mar: still cold, below 48°F
    case springReleaseSoon      // Mar–Apr: warming, 1–2 forecast days above 55°F
    case springReleaseReady     // Mar–May: ≥55°F sustained, release window open
    case springNesting          // May–Jun: well past release, females actively nesting
    case summerDevelopment      // Jun–Sep: spring bees done, larvae developing in tubes
    case summerLeafCutter       // Jun–Aug: ≥75°F, leaf cutter bee season
    case fallHarvest            // Oct–Nov: time to harvest and clean cocoons
}

// MARK: - Release Readiness

/// Tracks how close we are to the optimal release window.
enum ReleaseReadiness: Equatable {
    case notReady(warmDays: Int, threshold: Double)
    case gettingClose(warmDays: Int, threshold: Double)
    case readyNow(warmDays: Int, threshold: Double)

    var color: Color {
        switch self {
        case .notReady:     return Color(.systemRed)
        case .gettingClose: return AppConstants.orange
        case .readyNow:     return AppConstants.darkGreen
        }
    }

    var label: String {
        switch self {
        case .notReady:     return "Not Yet"
        case .gettingClose: return "Almost"
        case .readyNow:     return "Release Now"
        }
    }

    var icon: String {
        switch self {
        case .notReady:     return "xmark.circle.fill"
        case .gettingClose: return "exclamationmark.circle.fill"
        case .readyNow:     return "checkmark.circle.fill"
        }
    }

    var warmDaysCount: Int {
        switch self {
        case .notReady(let n, _), .gettingClose(let n, _), .readyNow(let n, _): return n
        }
    }

    var threshold: Double {
        switch self {
        case .notReady(_, let t), .gettingClose(_, let t), .readyNow(_, let t): return t
        }
    }
}

// MARK: - Advisory

/// The full bundle of guidance for the current moment — phase, headline, body copy, release window data.
struct BeeAdvisory {
    let phase: BeeSeasonPhase
    let phaseLabel: String
    let headline: String
    let body: String
    let sfIcon: String
    let accentColor: Color
    let releaseReadiness: ReleaseReadiness?
    let warmForecastDays: [Bool]   // parallel to dailyForecast — true = above threshold
    let tempThreshold: Double      // 55°F spring, 75°F leaf cutter, 0 otherwise
    let hasWeatherData: Bool
}

// MARK: - Advisor

/// Pure logic layer — no state, no side effects. Feed it weather + date and get back Dave Hunter's guidance.
struct BeeSeasonalAdvisor {

    static func advisory(
        weather: AppWeather?,
        forecast: [AppDayWeather],
        month: Int   // 1–12
    ) -> BeeAdvisory {
        let phase = currentPhase(weather: weather, forecast: forecast, month: month)
        let threshold = tempThreshold(for: phase)
        let warmDays = threshold > 0 ? forecast.map { $0.highTemp >= threshold } : []
        let warmCount = warmDays.filter { $0 }.count
        let readiness = releaseReadiness(phase: phase, warmCount: warmCount, threshold: threshold)

        return BeeAdvisory(
            phase: phase,
            phaseLabel: phaseLabel(for: phase),
            headline: headline(for: phase, readiness: readiness),
            body: body(for: phase, readiness: readiness),
            sfIcon: sfIcon(for: phase),
            accentColor: accentColor(for: phase),
            releaseReadiness: readiness,
            warmForecastDays: warmDays,
            tempThreshold: threshold,
            hasWeatherData: weather != nil
        )
    }

    // MARK: Phase Determination

    private static func currentPhase(
        weather: AppWeather?,
        forecast: [AppDayWeather],
        month: Int
    ) -> BeeSeasonPhase {
        let currentTemp = weather?.temperature ?? 0
        let warmDays55 = forecast.filter { $0.highTemp >= 55 }.count
        let warmDays75 = forecast.filter { $0.highTemp >= 75 }.count

        switch month {
        case 12, 1, 2:
            return .winterStorage

        case 3, 4:
            if warmDays55 >= 3 || currentTemp >= 55 {
                return .springReleaseReady
            } else if warmDays55 >= 1 || currentTemp >= 48 {
                return .springReleaseSoon
            } else {
                return .springWaiting
            }

        case 5:
            // Late spring — bees likely already released and nesting
            if currentTemp >= 55 || warmDays55 >= 1 {
                return .springNesting
            } else {
                return .springReleaseSoon
            }

        case 6:
            if warmDays75 >= 3 || currentTemp >= 75 { return .summerLeafCutter }
            return .summerDevelopment

        case 7, 8:
            if warmDays75 >= 1 || currentTemp >= 75 { return .summerLeafCutter }
            return .summerDevelopment

        case 9:
            return .summerDevelopment

        case 10, 11:
            return .fallHarvest

        default:
            return .winterStorage
        }
    }

    // MARK: Helpers

    private static func tempThreshold(for phase: BeeSeasonPhase) -> Double {
        switch phase {
        case .springWaiting, .springReleaseSoon, .springReleaseReady, .springNesting:
            return 55
        case .summerLeafCutter:
            return 75
        default:
            return 0
        }
    }

    private static func releaseReadiness(
        phase: BeeSeasonPhase,
        warmCount: Int,
        threshold: Double
    ) -> ReleaseReadiness? {
        switch phase {
        case .springWaiting, .springReleaseSoon, .springReleaseReady, .springNesting,
             .summerLeafCutter:
            if warmCount >= 3 { return .readyNow(warmDays: warmCount, threshold: threshold) }
            if warmCount >= 1 { return .gettingClose(warmDays: warmCount, threshold: threshold) }
            return .notReady(warmDays: warmCount, threshold: threshold)
        default:
            return nil
        }
    }

    // MARK: Phase Labels

    static func phaseLabel(for phase: BeeSeasonPhase) -> String {
        switch phase {
        case .winterStorage:      return "Winter Storage"
        case .springWaiting:      return "Pre-Spring"
        case .springReleaseSoon:  return "Spring Release Season"
        case .springReleaseReady: return "Spring Release Season"
        case .springNesting:      return "Spring Nesting Season"
        case .summerDevelopment:  return "Summer Development"
        case .summerLeafCutter:   return "Leaf Cutter Season"
        case .fallHarvest:        return "Fall Harvest Season"
        }
    }

    // MARK: Headlines

    static func headline(for phase: BeeSeasonPhase, readiness: ReleaseReadiness?) -> String {
        switch phase {
        case .winterStorage:
            return "Your mason bees are sleeping"
        case .springWaiting:
            return "Spring is coming — keep watching"
        case .springReleaseSoon:
            return "Getting close — watch the forecast"
        case .springReleaseReady:
            if case .readyNow = readiness { return "Time to release your mason bees" }
            return "Warming up — release window approaching"
        case .springNesting:
            return "Your bees are working"
        case .summerDevelopment:
            return "Mason bees are developing inside"
        case .summerLeafCutter:
            return "Leaf cutter bee season is open"
        case .fallHarvest:
            return "Harvest time — the most important step"
        }
    }

    // MARK: Body Copy (Dave Hunter voice)

    static func body(for phase: BeeSeasonPhase, readiness: ReleaseReadiness?) -> String {
        switch phase {
        case .winterStorage:
            return "Cleaned cocoons rest in the refrigerator at 35–40°F — not the freezer. Keep them in a paper bag inside an open container for a little airflow. Your bees are in diapause, conserving energy for the spring ahead. No action needed until March."

        case .springWaiting:
            return "Your mason bee cocoons are in the fridge, waiting for consistent 55°F days. That temperature threshold marks the start of fruit tree bloom — the two have co-evolved over thousands of years. Take cocoons out of the fridge about a week before you expect their first warm day, so they can acclimatize."

        case .springReleaseSoon:
            return "You're within reach of the release window. Mason bees emerge when daytime temperatures hold consistently above 55°F — the signal your first males need to rouse from diapause. Watch the 5-day forecast. When three warm days appear in a row, get your bee house ready."

        case .springReleaseReady:
            if case .readyNow = readiness {
                return "Multiple warm days are ahead — your window is open. Set your bee house facing southeast, 3–6 feet off the ground, with overhead rain protection nearby. Release cocoons near the entrance. Males emerge first; females follow within a week or two and begin nesting immediately."
            }
            return "Temperatures are climbing toward the 55°F release threshold. Prepare your bee house now — face it southeast, 3–6 feet off the ground, with overhead rain protection. Have your cocoons out of the fridge and ready. When three warm days arrive in a row, it's time."

        case .springNesting:
            return "Your females are on the wing, hauling pollen and building cells. Each egg cell requires 8–30 foraging trips to provision. Don't disturb the house. Keep clay-rich mud accessible nearby — females need it to seal every cell. Your job right now is to stay out of the way and watch them work."

        case .summerDevelopment:
            return "Your spring mason bees have finished flying. Inside the sealed tubes, larvae are eating their pollen provisions and spinning cocoons. Move nesting materials to a sheltered spot in a BeeGuard Bag to protect them from woodpeckers and summer rain. Harvest season begins in October."

        case .summerLeafCutter:
            return "Summer leaf cutter bees pick up right where mason bees leave off. They love the heat — consistent 75°F+ is their signal. Brilliant pollinators for summer vegetables, wildflowers, and clover. If you have leaf cutter cocoons, release them now near their shelter. Watch for neat circular holes in rose or lilac leaves — your sign they're nesting."

        case .fallHarvest:
            return "Pull your nesting tubes now and open them. Clean the cocoons in cool water to knock off mite eggs — this single step is the most important thing you'll do all year. It breaks the Chaetodactylus mite lifecycle that would otherwise devastate next spring's population. Discard soft or discoloured cocoons. Store the rest in the fridge."
        }
    }

    // MARK: Icons & Colours

    static func sfIcon(for phase: BeeSeasonPhase) -> String {
        switch phase {
        case .winterStorage:      return "snowflake"
        case .springWaiting:      return "thermometer.low"
        case .springReleaseSoon:  return "thermometer.medium"
        case .springReleaseReady: return "sun.max.fill"
        case .springNesting:      return "circle.hexagongrid.fill"
        case .summerDevelopment:  return "house.fill"
        case .summerLeafCutter:   return "leaf.fill"
        case .fallHarvest:        return "tray.and.arrow.down.fill"
        }
    }

    static func accentColor(for phase: BeeSeasonPhase) -> Color {
        switch phase {
        case .winterStorage:      return AppConstants.lightBlue
        case .springWaiting:      return AppConstants.lightBlue
        case .springReleaseSoon:  return AppConstants.orange
        case .springReleaseReady: return AppConstants.darkGreen
        case .springNesting:      return AppConstants.darkGreen
        case .summerDevelopment:  return AppConstants.orange
        case .summerLeafCutter:   return AppConstants.lightGreen
        case .fallHarvest:        return AppConstants.orange
        }
    }

    // MARK: Per-Day Bee Activity

    /// Assess expected bee activity from a forecast day's high temp and weather code.
    static func dailyBeeActivity(high: Double, weatherCode: Int) -> BeeActivity {
        let rainy = WMOCode.isRainy(weatherCode)
        if rainy || high < 50 { return .inactive }
        if high < 55 || high > 95 { return .low }
        return .active
    }

    // MARK: Release Tips (quoted, Dave Hunter voice)

    static func releaseTip(phase: BeeSeasonPhase, readiness: ReleaseReadiness?) -> String {
        if phase == .summerLeafCutter {
            return "\"Leaf cutter bees are your summer crew. When daytime temps hold above 75°F and summer blooms are going, it's time to release.\""
        }
        switch readiness {
        case .readyNow:
            return "\"Your first males will emerge within a day or two. Give them a few days to establish before expecting to see females. The whole window is about six weeks.\""
        case .gettingClose:
            return "\"Pull your cocoons out of the fridge about a week before their first warm day — they need time to acclimatize from the cold before emergence.\""
        default:
            return "\"The 55°F threshold isn't arbitrary — it's when fruit tree bloom begins, and your mason bees co-evolved with that calendar over thousands of years.\""
        }
    }
}
