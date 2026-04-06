import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showRegister = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppConstants.creamBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Logo / Branding
                        VStack(spacing: 12) {
                            Image(systemName: "hexagon.fill")
                                .font(.system(size: 80))
                                .foregroundColor(AppConstants.honeyGold)
                            Text("CrownBees")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(AppConstants.forestGreen)
                            Text("Your Mason Bee Companion")
                                .font(.subheadline)
                                .foregroundColor(AppConstants.warmBrown)
                        }
                        .padding(.top, 60)
                        
                        // Login Form
                        VStack(spacing: 16) {
                            TextField("Email", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                            
                            if !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                            
                            Button(action: login) {
                                Text("Log In")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(AppConstants.forestGreen)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Register Link
                        Button(action: { showRegister = true }) {
                            HStack {
                                Text("Don't have an account?")
                                    .foregroundColor(AppConstants.darkText)
                                Text("Register")
                                    .fontWeight(.bold)
                                    .foregroundColor(AppConstants.forestGreen)
                            }
                            .font(.subheadline)
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }
    
    private func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        guard authService.isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return
        }
        if !authService.login(email: email, password: password) {
            errorMessage = "Invalid email or password. Please try again."
        }
    }
}
