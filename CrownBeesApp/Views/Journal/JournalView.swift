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
            // Header
            Text("Bee Journal")
                .font(.largeTitle)
                .fontWeight(.bold)
                .tracking(-0.5)
                .foregroundStyle(AppConstants.onSurface)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, AppConstants.Spacing.md)
                .padding(.top, AppConstants.Spacing.md)
                .padding(.bottom, AppConstants.Spacing.sm)
                .background(AppConstants.surface)

            // Pollinator Chip Tab Selector
            HStack(spacing: AppConstants.Spacing.sm) {
                chipButton(tab: .release, title: "Release", icon: "arrow.up.circle.fill")
                chipButton(tab: .harvest, title: "Harvest", icon: "leaf.fill")
                chipButton(tab: .pest, title: "Pest", icon: "ant.fill")
            }
            .padding(.horizontal, AppConstants.Spacing.md)
            .padding(.vertical, AppConstants.Spacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppConstants.surfaceContainerLow)

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
        .background(AppConstants.surface)
        .navigationTitle("Journal")
    }

    @ViewBuilder
    private func chipButton(tab: JournalTab, title: String, icon: String) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                selectedTab = tab
            }
        }) {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, AppConstants.Spacing.md)
                .padding(.vertical, AppConstants.Spacing.sm)
                .background(selectedTab == tab ? AppConstants.secondaryContainer : AppConstants.surfaceContainerHighest)
                .foregroundStyle(selectedTab == tab ? AppConstants.secondary : AppConstants.onSurfaceVariant)
                .clipShape(Capsule())
        }
    }
}
