import SwiftUI

enum JournalTab {
    case release
    case harvest
    case pest
}

struct JournalView: View {
    @State private var selectedTab: JournalTab = .release

    private let bgGradient = LinearGradient(
        colors: [Color(hex: "#1a3d2a"), Color(hex: "#4a7c5a")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        VStack(spacing: 0) {
            // Glass chip tab selector
            GlassEffectContainer {
                HStack(spacing: AppConstants.Spacing.sm) {
                    chipButton(tab: .release, title: "Release", icon: "arrow.up.circle.fill")
                    chipButton(tab: .harvest, title: "Harvest", icon: "leaf.fill")
                    chipButton(tab: .pest, title: "Pest", icon: "ant.fill")
                }
                .padding(.horizontal, AppConstants.Spacing.md)
                .padding(.vertical, AppConstants.Spacing.xs)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, AppConstants.Spacing.md)
            .padding(.vertical, AppConstants.Spacing.sm)

            switch selectedTab {
            case .release: ReleaseLogView()
            case .harvest: HarvestLogView()
            case .pest:    PestLogView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(bgGradient.ignoresSafeArea())
    }

    @ViewBuilder
    private func chipButton(tab: JournalTab, title: String, icon: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                selectedTab = tab
            }
        } label: {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.medium))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, AppConstants.Spacing.md)
                .padding(.vertical, AppConstants.Spacing.sm)
                .foregroundStyle(selectedTab == tab ? Color(hex: "#865300") : .white.opacity(0.85))
                .glassEffect(in: .capsule)
        }
    }
}
