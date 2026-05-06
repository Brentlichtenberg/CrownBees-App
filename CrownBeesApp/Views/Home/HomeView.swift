import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        ZStack {
            forestGreenBackground
            ScrollView {
                VStack(alignment: .leading, spacing: AppConstants.Spacing.lg) {
                    heroSection
                    featureCards
                }
                .padding(.horizontal, AppConstants.Spacing.lg)
                .padding(.bottom, AppConstants.Spacing.lg)
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: - Subviews

    private var forestGreenBackground: some View {
        LinearGradient(
            colors: [Color(hex: "#1a3d2a"), Color(hex: "#4a7c5a")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
            Image(systemName: "hexagon.fill")
                .font(.system(size: 40))
                .foregroundStyle(AppConstants.primary)
            Text("Crown Bees")
                .font(.system(size: 42, weight: .black))
                .tracking(-1.5)
                .foregroundStyle(.white)
            Text("Solitary Bee Companions")
                .font(.title3)
                .foregroundStyle(.white.opacity(0.8))
            Text("Your solitary bee companion — track weather, log journal entries, and access resources.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.65))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, AppConstants.Spacing.xs)
        }
        .padding(.top, AppConstants.Spacing.xl)
    }

    private var featureCards: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
            Text("Your Tools")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.white.opacity(0.6))
                .textCase(.uppercase)
                .tracking(1)

            GlassEffectContainer {
                VStack(spacing: 0) {
                    featureCard(
                        icon: "cloud.sun.fill",
                        title: "Personalised Weather",
                        description: "Track local weather conditions for your bees.",
                        destination: .weather
                    )
                    Divider().opacity(0.15)
                    featureCard(
                        icon: "book.fill",
                        title: "Beekeeping Journal",
                        description: "Log releases, harvests, and pest observations.",
                        destination: .journal
                    )
                    Divider().opacity(0.15)
                    featureCard(
                        icon: "link",
                        title: "Resources",
                        description: "Access guides and products from CrownBees.",
                        destination: .resources
                    )
                }
                .glassEffect(in: .rect(cornerRadius: AppConstants.Radius.lg))
            }
        }
    }

    @ViewBuilder
    private func featureCard(icon: String, title: String, description: String, destination: AppTab) -> some View {
        Button {
            selectedTab = destination
        } label: {
            HStack(spacing: AppConstants.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(AppConstants.primary)
                    .frame(width: 44, height: 44)
                    .background(AppConstants.primary.opacity(0.18))
                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))

                VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary.opacity(0.7))
            }
            .padding(AppConstants.Spacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
