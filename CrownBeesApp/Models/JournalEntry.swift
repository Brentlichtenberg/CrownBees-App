import Foundation

// MARK: - Bee Release Entry
struct ReleaseEntry: Codable, Identifiable {
    var id: UUID = UUID()
    var date: Date
    var numberOfBees: Int
    var notes: String
}

// MARK: - Harvest Entry
struct HarvestEntry: Codable, Identifiable {
    var id: UUID = UUID()
    var date: Date
    var numberOfBees: Int
    var notes: String
}

// MARK: - Pest Entry
struct PestEntry: Codable, Identifiable {
    var id: UUID = UUID()
    var date: Date
    var pestType: PestType
    var severity: PestSeverity
    var notes: String
}

enum PestType: String, Codable, CaseIterable {
    case mites = "Mites"
    case wasps = "Wasps"
    case ants = "Ants"
    case birds = "Birds"
    case other = "Other"
}

enum PestSeverity: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}
