import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Image Placeholder
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [AppConstants.darkGreen, AppConstants.orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 260)
                    
                    VStack(spacing: 12) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.9))
                        Text("Hero Image Coming Soon")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.85))
                    }
                }
                
                // Welcome Content
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome to CrownBees!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(AppConstants.darkGreen)
                        
                        Text("Your mason bee companion app — content coming soon.")
                            .font(.body)
                            .foregroundColor(AppConstants.darkText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Divider()
                    
                    // Feature highlight cards
                    VStack(spacing: 12) {
                        featureCard(
                            icon: "cloud.sun.fill",
                            title: "Personalised Weather",
                            description: "Track local weather conditions for your bees.",
                            color: AppConstants.orange
                        )
                        featureCard(
                            icon: "book.fill",
                            title: "Beekeeping Journal",
                            description: "Log releases, harvests, and pest observations.",
                            color: AppConstants.navyBlue
                        )
                        featureCard(
                            icon: "link",
                            title: "Resources",
                            description: "Access guides and products from CrownBees.",
                            color: AppConstants.darkGreen
                        )
                    }
                }
                .padding(24)
                .background(AppConstants.beige)
            }
        }
        .background(AppConstants.beige)
        .navigationTitle("Home")
    }
    
    @ViewBuilder
    private func featureCard(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
                .frame(width: 48, height: 48)
                .background(color.opacity(0.15))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppConstants.darkText)
                Text(description)
                    .font(.caption)
                    .foregroundColor(AppConstants.darkText.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
