import SwiftUI
import SafariServices

struct ResourcesView: View {
    @State private var selectedURL: IdentifiableURL? = nil

    private let bgGradient = LinearGradient(
        colors: [Color(hex: "#1a3d2a"), Color(hex: "#4a7c5a")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        ScrollView {
            VStack(spacing: AppConstants.Spacing.lg) {
                // Hero Glass Card
                GlassEffectContainer {
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
                        Image(systemName: "link.circle.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(.primary)
                        Text("Pollinator Resources")
                            .font(.system(size: 32, weight: .black))
                            .tracking(-0.3)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                        Text("Access all CrownBees resources, guides, and products.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AppConstants.Spacing.lg)
                    .glassEffect(in: .rect(cornerRadius: AppConstants.Radius.lg))
                }

                // Main Website Button
                Button(action: {
                    if let url = URL(string: AppConstants.crownBeesURL) {
                        selectedURL = IdentifiableURL(url: url)
                    }
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
                            colors: [Color(hex: "#865300"), Color(hex: "#b87800")],
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
                        .foregroundStyle(.white)

                    GlassEffectContainer {
                        VStack(spacing: AppConstants.Spacing.sm) {
                            resourceCard(
                                icon: "star.fill",
                                title: "Getting Started",
                                description: "New to solitary bees? Start here.",
                                color: Color(hex: "#865300"),
                                urlString: AppConstants.gettingStartedURL
                            )
                            resourceCard(
                                icon: "cart.fill",
                                title: "Products",
                                description: "Browse all CrownBees products.",
                                color: .white.opacity(0.9),
                                urlString: AppConstants.productsURL
                            )
                            resourceCard(
                                icon: "questionmark.circle.fill",
                                title: "Mason Bee FAQ",
                                description: "Answers to common questions.",
                                color: .white.opacity(0.9),
                                urlString: AppConstants.faqURL
                            )
                        }
                        .padding(AppConstants.Spacing.sm)
                        .glassEffect(in: .rect(cornerRadius: AppConstants.Radius.lg))
                    }
                }
            }
            .padding(AppConstants.Spacing.md)
            .padding(.bottom, 48)
        }
        .background(bgGradient.ignoresSafeArea())
        .navigationTitle("Resources")
        .sheet(item: $selectedURL) { item in
            SafariView(url: item.url)
                .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private func resourceCard(icon: String, title: String, description: String, color: Color, urlString: String) -> some View {
        Button(action: {
            if let url = URL(string: urlString) {
                selectedURL = IdentifiableURL(url: url)
            }
        }) {
            HStack(spacing: AppConstants.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))

                VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .padding(AppConstants.Spacing.md)
            .background(.white.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))
        }
    }
}

// MARK: - Identifiable URL wrapper
struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}

// MARK: - Safari View Wrapper
struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
