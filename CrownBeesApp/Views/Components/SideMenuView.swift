import SwiftUI

enum AppScreen {
    case home
    case weather
    case journal
    case resources
}

struct SideMenuView: View {
    @Binding var selectedScreen: AppScreen
    @Binding var isMenuOpen: Bool
    @EnvironmentObject var authService: AuthService

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header — amber gradient with glassmorphism overlay
            ZStack(alignment: .topLeading) {
                LinearGradient(
                    colors: [AppConstants.primary, AppConstants.primaryContainer],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Decorative hexagon watermark
                Image(systemName: "hexagon.fill")
                    .font(.system(size: 160))
                    .foregroundStyle(.white.opacity(0.08))
                    .offset(x: 80, y: -20)

                Rectangle()
                    .fill(.ultraThinMaterial.opacity(0.2))

                VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
                    Image(systemName: "hexagon.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.white)
                    Text("CrownBees")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    if let user = authService.currentUser {
                        Text(user.email)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.75))
                    }
                }
                .padding(.horizontal, AppConstants.Spacing.lg)
                .padding(.top, 60)
                .padding(.bottom, AppConstants.Spacing.xl)
            }
            .frame(maxWidth: .infinity)
            .fixedSize(horizontal: false, vertical: true)

            // Menu Items
            VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                menuItem(title: "Home", icon: "house.fill", screen: .home)
                menuItem(title: "Personalised Weather", icon: "cloud.sun.fill", screen: .weather)
                menuItem(title: "Journal", icon: "book.fill", screen: .journal)
                menuItem(title: "Resources", icon: "link", screen: .resources)
            }
            .padding(.vertical, AppConstants.Spacing.md)
            .background(AppConstants.surface)

            Spacer()

            // Log Out
            Button(action: {
                withAnimation {
                    isMenuOpen = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    authService.logout()
                }
            }) {
                HStack(spacing: AppConstants.Spacing.md) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 18))
                        .foregroundStyle(AppConstants.primary)
                        .frame(width: 28)
                    Text("Log Out")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(AppConstants.primary)
                }
                .padding(.horizontal, AppConstants.Spacing.lg)
                .padding(.vertical, AppConstants.Spacing.md)
            }
            .background(AppConstants.surface)
        }
        .background(AppConstants.surface)
        .frame(maxHeight: .infinity)
    }

    @ViewBuilder
    private func menuItem(title: String, icon: String, screen: AppScreen) -> some View {
        let isSelected = selectedScreen == screen
        HStack(spacing: AppConstants.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(isSelected ? AppConstants.secondary : AppConstants.onSurfaceVariant)
                .frame(width: 28)
            Text(title)
                .font(.body)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? AppConstants.secondary : AppConstants.onSurface)
            Spacer()
        }
        .padding(.horizontal, AppConstants.Spacing.lg)
        .padding(.vertical, 14)
        .background(
            isSelected
                ? AppConstants.secondaryContainer.opacity(0.5)
                : Color.clear
        )
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))
        .padding(.horizontal, AppConstants.Spacing.sm)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                selectedScreen = screen
                isMenuOpen = false
            }
        }
    }
}
