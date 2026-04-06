import Foundation

class StorageService {
    static let shared = StorageService()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Release Entries
    func saveReleaseEntries(_ entries: [ReleaseEntry]) {
        if let data = try? encoder.encode(entries) {
            UserDefaults.standard.set(data, forKey: AppConstants.releaseEntriesKey)
        }
    }
    
    func loadReleaseEntries() -> [ReleaseEntry] {
        guard let data = UserDefaults.standard.data(forKey: AppConstants.releaseEntriesKey),
              let entries = try? decoder.decode([ReleaseEntry].self, from: data) else {
            return []
        }
        return entries
    }
    
    // MARK: - Harvest Entries
    func saveHarvestEntries(_ entries: [HarvestEntry]) {
        if let data = try? encoder.encode(entries) {
            UserDefaults.standard.set(data, forKey: AppConstants.harvestEntriesKey)
        }
    }
    
    func loadHarvestEntries() -> [HarvestEntry] {
        guard let data = UserDefaults.standard.data(forKey: AppConstants.harvestEntriesKey),
              let entries = try? decoder.decode([HarvestEntry].self, from: data) else {
            return []
        }
        return entries
    }
    
    // MARK: - Pest Entries
    func savePestEntries(_ entries: [PestEntry]) {
        if let data = try? encoder.encode(entries) {
            UserDefaults.standard.set(data, forKey: AppConstants.pestEntriesKey)
        }
    }
    
    func loadPestEntries() -> [PestEntry] {
        guard let data = UserDefaults.standard.data(forKey: AppConstants.pestEntriesKey),
              let entries = try? decoder.decode([PestEntry].self, from: data) else {
            return []
        }
        return entries
    }
}
