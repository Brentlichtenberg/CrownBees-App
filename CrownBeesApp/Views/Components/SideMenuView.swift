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
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "hexagon.fill")
                    .font(.system(size: 48))
                    .foregroundColor(AppConstants.honeyGold)
                Text("CrownBees")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                if let user = authService.currentUser {
                    Text(user.email)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            .padding(.bottom, 32)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppConstants.forestGreen)
            
            // Menu Items
            VStack(alignment: .leading, spacing: 4) {
                menuItem(title: "Home", icon: "house.fill", screen: .home)
                menuItem(title: "Personalised Weather", icon: "cloud.sun.fill", screen: .weather)
                menuItem(title: "Journal", icon: "book.fill", screen: .journal)
                menuItem(title: "Resources", icon: "link", screen: .resources)
            }
            .padding(.vertical, 16)
            .background(AppConstants.creamBackground)
            
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
                HStack(spacing: 16) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                        .frame(width: 28)
                    Text("Log Out")
                        .font(.body)
                        .foregroundColor(.red)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
            .background(AppConstants.creamBackground)
        }
        .background(AppConstants.creamBackground)
        .frame(maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func menuItem(title: String, icon: String, screen: AppScreen) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedScreen = screen
                isMenuOpen = false
            }
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(selectedScreen == screen ? AppConstants.forestGreen : AppConstants.warmBrown)
                    .frame(width: 28)
                Text(title)
                    .font(.body)
                    .fontWeight(selectedScreen == screen ? .semibold : .regular)
                    .foregroundColor(selectedScreen == screen ? AppConstants.forestGreen : AppConstants.darkText)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                selectedScreen == screen
                    ? AppConstants.honeyGold.opacity(0.2)
                    : Color.clear
            )
        }
    }
}
