import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var authService: AuthService
    @State private var selectedTab: AppTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    NavigationStack {
                        HomeView(selectedTab: $selectedTab)
                            .navigationTitle("Home")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar { profileMenu }
                    }
                case .journal:
                    NavigationStack {
                        JournalView()
                            .navigationTitle("Journal")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar { profileMenu }
                    }
                case .weather:
                    NavigationStack {
                        WeatherView()
                            .navigationTitle("Weather")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar { profileMenu }
                    }
                case .resources:
                    NavigationStack {
                        ResourcesView()
                            .navigationTitle("Resources")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar { profileMenu }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            FloatingTabBar(selection: $selectedTab)
                .padding(.bottom, 8)
                .padding(.horizontal, 0)
        }
        .ignoresSafeArea(.keyboard)
    }

    @ToolbarContentBuilder
    private var profileMenu: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                if let user = authService.currentUser {
                    Text(user.email)
                        .font(.caption)
                }
                Divider()
                Button(role: .destructive) {
                    authService.logout()
                } label: {
                    Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                }
            } label: {
                Image(systemName: "person.circle")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(AppConstants.primary)
            }
        }
    }
}
