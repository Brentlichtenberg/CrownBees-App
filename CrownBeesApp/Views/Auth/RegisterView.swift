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
            AppConstants.surface.ignoresSafeArea()

            ScrollView {
                VStack(spacing: AppConstants.Spacing.xl) {

                    // MARK: - Header
                    VStack(spacing: AppConstants.Spacing.sm) {
                        ZStack {
                            Circle()
                                .fill(AppConstants.primary.opacity(0.12))
                                .frame(width: 72, height: 72)
                            Image(systemName: "hexagon.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(AppConstants.primary)
                        }
                        Text("Create Account")
                            .font(.system(size: 30, weight: .bold))
                            .tracking(-0.5)
                            .foregroundStyle(AppConstants.onSurface)
                        Text("Join the Crown Bees community")
                            .font(.subheadline)
                            .foregroundStyle(AppConstants.onSurfaceVariant)
                    }
                    .padding(.top, AppConstants.Spacing.xxl)

                    // MARK: - Form Card
                    VStack(spacing: AppConstants.Spacing.md) {
                        ghostField(placeholder: "Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                        ghostSecureField(placeholder: "Password", text: $password)
                        ghostSecureField(placeholder: "Confirm Password", text: $confirmPassword)
                        ghostField(placeholder: "Zip Code", text: $zipCode)
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
                                    .foregroundStyle(AppConstants.onSurfaceVariant)
                                Text("Log In")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(AppConstants.secondary)
                            }
                            .font(.subheadline)
                        }
                    }
                    .padding(AppConstants.Spacing.lg)
                    .background(AppConstants.surfaceContainerLowest)
                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.lg))
                    .shadow(color: AppConstants.shadowColor.opacity(0.07), radius: 20, x: 0, y: 6)
                    .padding(.horizontal, AppConstants.Spacing.md)
                }
            }
        }
        .navigationBarBackButtonHidden(false)
    }

    @ViewBuilder
    private func ghostField(placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .padding(AppConstants.Spacing.md)
            .background(AppConstants.surfaceContainerLow)
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.Radius.md)
                    .stroke(AppConstants.onSurface.opacity(0.12), lineWidth: 1)
            )
    }

    @ViewBuilder
    private func ghostSecureField(placeholder: String, text: Binding<String>) -> some View {
        SecureField(placeholder, text: text)
            .padding(AppConstants.Spacing.md)
            .background(AppConstants.surfaceContainerLow)
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.Radius.md)
                    .stroke(AppConstants.onSurface.opacity(0.12), lineWidth: 1)
            )
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
