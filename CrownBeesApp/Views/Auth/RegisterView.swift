import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var zipCode = ""
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            AppConstants.creamBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "hexagon.fill")
                            .font(.system(size: 60))
                            .foregroundColor(AppConstants.honeyGold)
                        Text("Create Account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(AppConstants.forestGreen)
                        Text("Join the CrownBees community")
                            .font(.subheadline)
                            .foregroundColor(AppConstants.warmBrown)
                    }
                    .padding(.top, 40)
                    
                    // Registration Form
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
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                        
                        TextField("Zip Code", text: $zipCode)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        
                        Button(action: register) {
                            Text("Create Account")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppConstants.forestGreen)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Back to Login
                    Button(action: { dismiss() }) {
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(AppConstants.darkText)
                            Text("Log In")
                                .fontWeight(.bold)
                                .foregroundColor(AppConstants.forestGreen)
                        }
                        .font(.subheadline)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(false)
    }
    
    private func register() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty, !zipCode.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        guard authService.isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return
        }
        guard zipCode.count == 5, zipCode.allSatisfy({ $0.isNumber }) else {
            errorMessage = "Please enter a valid 5-digit zip code."
            return
        }
        if !authService.register(email: email, password: password, zipCode: zipCode) {
            errorMessage = "Registration failed. Please try again."
        }
    }
}
