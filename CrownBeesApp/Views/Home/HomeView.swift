import SwiftUI

struct HomeView: View {
    @Binding var selectedScreen: AppScreen

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Section
                ZStack(alignment: .trailing) {
                    LinearGradient(
                        colors: [AppConstants.primary, AppConstants.primaryContainer],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 300)

                    // Decorative hexagon watermark
                    Image(systemName: "hexagon.fill")
                        .font(.system(size: 220))
                        .foregroundStyle(.white.opacity(0.1))
                        .offset(x: 60, y: 20)

                    VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
                        Text("Crown Bees")
                            .font(.system(size: 42, weight: .black))
                            .tracking(-1.5)
                            .foregroundStyle(.white)
                        Text("Solitary Bee Companions")
                            .font(.title3)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, AppConstants.Spacing.lg)
                    .padding(.bottom, AppConstants.Spacing.xl)
                }

                // Welcome Content
                VStack(alignment: .leading, spacing: AppConstants.Spacing.lg) {
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
                        Text("Welcome to CrownBees!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .tracking(-0.5)
                            .foregroundStyle(AppConstants.onSurface)

                        Text("Your solitary bee companion app — content coming soon.")
                            .font(.body)
                            .foregroundStyle(AppConstants.onSurfaceVariant)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Feature highlight cards — tap to navigate
                    VStack(spacing: AppConstants.Spacing.sm) {
                        featureCard(
                            icon: "cloud.sun.fill",
                            title: "Personalised Weather",
                            description: "Track local weather conditions for your bees.",
                            color: AppConstants.primary,
                            destination: .weather
                        )
                        featureCard(
                            icon: "book.fill",
                            title: "Beekeeping Journal",
                            description: "Log releases, harvests, and pest observations.",
                            color: AppConstants.secondary,
                            destination: .journal
                        )
                        featureCard(
                            icon: "link",
                            title: "Resources",
                            description: "Access guides and products from CrownBees.",
                            color: AppConstants.secondary,
                            destination: .resources
                        )
                    }
                }
                .padding(AppConstants.Spacing.lg)
                .background(AppConstants.surface)
            }
        }
        .background(AppConstants.surface.ignoresSafeArea())
        .navigationTitle("Home")
    }

    @ViewBuilder
    private func featureCard(icon: String, title: String, description: String, color: Color, destination: AppScreen) -> some View {
        Button {
            selectedScreen = destination
        } label: {
            HStack(spacing: AppConstants.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundStyle(color)
                    .frame(width: 48, height: 48)
                    .background(color.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))

                VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(AppConstants.onSurface)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(AppConstants.onSurfaceVariant)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(AppConstants.onSurfaceVariant)
            }
            .padding(AppConstants.Spacing.md)
            .background(AppConstants.surfaceContainerLowest)
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.lg))
            .shadow(color: AppConstants.shadowColor.opacity(0.06), radius: 20, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}
