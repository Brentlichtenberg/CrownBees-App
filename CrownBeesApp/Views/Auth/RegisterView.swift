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
            LinearGradient(
                colors: [Color(hex: "#1a3d2a"), Color(hex: "#4a7c5a")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: AppConstants.Spacing.xl) {
                    headerSection
                    registerCard
                }
                .padding(.bottom, AppConstants.Spacing.xxl)
            }
        }
        .navigationBarBackButtonHidden(false)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: - Subviews

    private var headerSection: some View {
        VStack(spacing: AppConstants.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(AppConstants.primary.opacity(0.18))
                    .frame(width: 72, height: 72)
                Image(systemName: "hexagon.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(AppConstants.primary)
            }
            Text("Create Account")
                .font(.system(size: 30, weight: .bold))
                .tracking(-0.5)
                .foregroundStyle(.white)
            Text("Join the Crown Bees community")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.top, AppConstants.Spacing.xxl)
    }

    private var registerCard: some View {
        GlassEffectContainer {
            VStack(spacing: AppConstants.Spacing.md) {
                GlassInputField(placeholder: "Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()

                GlassInputField(placeholder: "Password", text: $password, isSecure: true)
                GlassInputField(placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)

                GlassInputField(placeholder: "Zip Code", text: $zipCode)
                    .keyboardType(.numberPad)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(action: register) {
                    Text("Create Account")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppConstants.Spacing.md)
                        .background(
                            LinearGradient(
                                colors: [AppConstants.primary, AppConstants.primaryContainer],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }

                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundStyle(.secondary)
                        Text("Log In")
                            .fontWeight(.semibold)
                            .foregroundStyle(AppConstants.primary)
                    }
                    .font(.subheadline)
                }
            }
            .padding(AppConstants.Spacing.lg)
            .glassEffect(in: .rect(cornerRadius: AppConstants.Radius.lg))
        }
        .padding(.horizontal, AppConstants.Spacing.md)
    }

    // MARK: - Actions

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
