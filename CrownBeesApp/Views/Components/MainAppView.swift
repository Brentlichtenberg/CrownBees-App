import SwiftUI

struct MainAppView: View {
    @State private var selectedScreen: AppScreen = .home
    @State private var isMenuOpen: Bool = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Main Content
            NavigationStack {
                Group {
                    switch selectedScreen {
                    case .home:
                        HomeView(selectedScreen: $selectedScreen)
                    case .weather:
                        WeatherView()
                    case .journal:
                        JournalView()
                    case .resources:
                        ResourcesView()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        MenuButton(isMenuOpen: $isMenuOpen)
                    }
                }
            }
            
            // Overlay dimming when menu is open
            if isMenuOpen {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isMenuOpen = false
                        }
                    }
                    .transition(.opacity)
            }
            
            // Side Drawer (slides from trailing edge)
            if isMenuOpen {
                SideMenuView(selectedScreen: $selectedScreen, isMenuOpen: $isMenuOpen)
                    .frame(width: 280)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: -4, y: 0)
                    .transition(.move(edge: .trailing))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isMenuOpen)
    }
}
