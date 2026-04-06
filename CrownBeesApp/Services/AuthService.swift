import Foundation
import Combine

class AuthService: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    
    init() {
        // Check for persisted session
        self.isLoggedIn = UserDefaults.standard.bool(forKey: AppConstants.isLoggedInKey)
        if let userData = UserDefaults.standard.data(forKey: AppConstants.currentUserKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
        }
    }
    
    /// Register a new user and log them in
    func register(email: String, password: String, zipCode: String) -> Bool {
        let newUser = User(email: email, password: password, zipCode: zipCode)
        guard let encoded = try? JSONEncoder().encode(newUser) else { return false }
        UserDefaults.standard.set(encoded, forKey: AppConstants.currentUserKey)
        UserDefaults.standard.set(true, forKey: AppConstants.isLoggedInKey)
        self.currentUser = newUser
        self.isLoggedIn = true
        return true
    }
    
    /// Log in with stored credentials
    func login(email: String, password: String) -> Bool {
        guard let userData = UserDefaults.standard.data(forKey: AppConstants.currentUserKey),
              let storedUser = try? JSONDecoder().decode(User.self, from: userData) else {
            return false
        }
        if storedUser.email == email && storedUser.password == password {
            self.currentUser = storedUser
            UserDefaults.standard.set(true, forKey: AppConstants.isLoggedInKey)
            self.isLoggedIn = true
            return true
        }
        return false
    }
    
    /// Log out the current user
    func logout() {
        UserDefaults.standard.set(false, forKey: AppConstants.isLoggedInKey)
        self.isLoggedIn = false
        self.currentUser = nil
    }
    
    /// Validation helpers
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }
}
