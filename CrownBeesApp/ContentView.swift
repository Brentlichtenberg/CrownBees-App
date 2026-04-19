import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        Group {
            // TESTING: login suppressed — go straight to main app
            // if authService.isLoggedIn {
            //     MainAppView()
            // } else {
            //     LoginView()
            // }
            MainAppView()
        }
    }
}
