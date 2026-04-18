import SwiftUI

enum JournalTab {
    case release
    case harvest
    case pest
}

struct JournalView: View {
    @State private var selectedTab: JournalTab = .release
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab Selector
            Picker("Journal Section", selection: $selectedTab) {
                Text("Release").tag(JournalTab.release)
                Text("Harvest").tag(JournalTab.harvest)
                Text("Pest").tag(JournalTab.pest)
            }
            .pickerStyle(.segmented)
            .padding(16)
            .background(AppConstants.beige)
            
            // Content
            switch selectedTab {
            case .release:
                ReleaseLogView()
            case .harvest:
                HarvestLogView()
            case .pest:
                PestLogView()
            }
        }
        .background(AppConstants.beige)
        .navigationTitle("Journal")
    }
}
