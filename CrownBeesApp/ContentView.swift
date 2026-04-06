import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        Group {
            if authService.isLoggedIn {
                MainAppView()
            } else {
                LoginView()
            }
        }
    }
}
