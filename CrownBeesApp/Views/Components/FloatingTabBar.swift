import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case home, journal, weather, resources

    var id: String { rawValue }

    var label: String {
        switch self {
        case .home: return "Home"
        case .journal: return "Journal"
        case .weather: return "Weather"
        case .resources: return "Resources"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .journal: return "book.fill"
        case .weather: return "cloud.sun.fill"
        case .resources: return "link"
        }
    }
}

struct FloatingTabBar: View {
    @Binding var selection: AppTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                tabItem(tab)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .glassEffect(in: .capsule)
        .padding(.horizontal, 24)
        .shadow(color: .black.opacity(0.2), radius: 24, y: 8)
    }

    @ViewBuilder
    private func tabItem(_ tab: AppTab) -> some View {
        let isSelected = selection == tab
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                selection = tab
            }
        } label: {
            VStack(spacing: 3) {
                Image(systemName: tab.icon)
                    .font(.system(size: isSelected ? 22 : 20, weight: .semibold))
                Text(tab.label)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundStyle(isSelected ? AppConstants.primary : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .background {
                if isSelected {
                    Capsule()
                        .fill(AppConstants.primary.opacity(0.18))
                        .shadow(color: AppConstants.primary.opacity(0.45), radius: 10)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
