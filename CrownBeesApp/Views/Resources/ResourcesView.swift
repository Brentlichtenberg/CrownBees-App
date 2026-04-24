import SwiftUI
import SafariServices

struct ResourcesView: View {
    @State private var showSafari = false
    @State private var currentURL: URL? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Editorial Hero — forest green gradient
                ZStack(alignment: .trailing) {
                    LinearGradient(
                        colors: [AppConstants.secondary, AppConstants.secondary.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 220)

                    // Decorative hexagon watermark
                    Image(systemName: "hexagon.fill")
                        .font(.system(size: 180))
                        .foregroundStyle(.white.opacity(0.08))
                        .offset(x: 50, y: 10)

                    VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
                        Image(systemName: "link.circle.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(.white.opacity(0.9))
                        Text("Bee Resources")
                            .font(.system(size: 34, weight: .black))
                            .tracking(-0.3)
                            .foregroundStyle(.white)
                        Text("Access all CrownBees resources, guides, and products.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.85))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, AppConstants.Spacing.lg)
                    .padding(.bottom, AppConstants.Spacing.xl)
                }

                // Content
                VStack(spacing: AppConstants.Spacing.lg) {
                    // Main Website Button
                    Button(action: {
                        currentURL = URL(string: AppConstants.crownBeesURL)
                        showSafari = true
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .font(.system(size: 20))
                            Text("Visit CrownBees Website")
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                        }
                        .padding(AppConstants.Spacing.md)
                        .background(
                            LinearGradient(
                                colors: [AppConstants.primary, AppConstants.primaryContainer],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                    }

                    // Quick Links
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
                        Text("Quick Links")
                            .font(.title2)
                            .fontWeight(.bold)
                            .tracking(-0.3)
                            .foregroundStyle(AppConstants.onSurface)

                        resourceCard(
                            icon: "star.fill",
                            title: "Getting Started",
                            description: "New to solitary bees? Start here.",
                            color: AppConstants.primary,
                            urlString: AppConstants.gettingStartedURL
                        )

                        resourceCard(
                            icon: "cart.fill",
                            title: "Products",
                            description: "Browse all CrownBees products.",
                            color: AppConstants.secondary,
                            urlString: AppConstants.productsURL
                        )

                        resourceCard(
                            icon: "questionmark.circle.fill",
                            title: "FAQ",
                            description: "Answers to common questions.",
                            color: AppConstants.secondary,
                            urlString: AppConstants.faqURL
                        )
                    }
                    .padding(AppConstants.Spacing.lg)
                    .background(AppConstants.surfaceContainerLowest)
                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.lg))
                    .shadow(color: AppConstants.shadowColor.opacity(0.06), radius: 20, x: 0, y: 6)
                }
                .padding(AppConstants.Spacing.md)
                .background(AppConstants.surface)
            }
        }
        .background(AppConstants.surface.ignoresSafeArea())
        .navigationTitle("Resources")
        .sheet(isPresented: $showSafari) {
            if let url = currentURL {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
    }

    @ViewBuilder
    private func resourceCard(icon: String, title: String, description: String, color: Color, urlString: String) -> some View {
        Button(action: {
            currentURL = URL(string: urlString)
            showSafari = true
        }) {
            HStack(spacing: AppConstants.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))

                VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(AppConstants.onSurface)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(AppConstants.onSurfaceVariant)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(AppConstants.primary)
                    .font(.caption)
            }
            .padding(AppConstants.Spacing.md)
            .background(AppConstants.surfaceContainerLow)
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))
        }
    }
}

// MARK: - Safari View Wrapper
struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
