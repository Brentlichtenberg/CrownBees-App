import SwiftUI
import SafariServices

struct ResourcesView: View {
    @State private var showSafari = false
    @State private var currentURL: URL? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Card
                VStack(spacing: 12) {
                    Image(systemName: "link.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(AppConstants.darkGreen)
                    Text("CrownBees Resources")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppConstants.darkGreen)
                    Text("Access all CrownBees resources, guides, and products.")
                        .font(.body)
                        .foregroundColor(AppConstants.darkText)
                        .multilineTextAlignment(.center)
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
                
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
                    .padding(18)
                    .background(AppConstants.darkGreen)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                
                // Quick Links
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Links")
                        .font(.headline)
                        .foregroundColor(AppConstants.darkGreen)
                    
                    resourceCard(
                        icon: "star.fill",
                        title: "Getting Started",
                        description: "New to mason bees? Start here.",
                        color: AppConstants.orange,
                        urlString: AppConstants.gettingStartedURL
                    )
                    
                    resourceCard(
                        icon: "cart.fill",
                        title: "Products",
                        description: "Browse all CrownBees products.",
                        color: AppConstants.darkGreen,
                        urlString: AppConstants.productsURL
                    )
                    
                    resourceCard(
                        icon: "questionmark.circle.fill",
                        title: "FAQ",
                        description: "Answers to common questions.",
                        color: AppConstants.lightBlue,
                        urlString: AppConstants.faqURL
                    )
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
            }
            .padding(16)
        }
        .background(AppConstants.beige)
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
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.15))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(AppConstants.darkText)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(AppConstants.darkText.opacity(0.6))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(AppConstants.darkText.opacity(0.4))
                    .font(.caption)
            }
            .padding(16)
            .background(AppConstants.beige)
            .cornerRadius(12)
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
