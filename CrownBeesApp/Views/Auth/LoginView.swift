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
                AppConstants.surface.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {

                        // MARK: - Amber hero branding
                        ZStack(alignment: .bottomLeading) {
                            LinearGradient(
                                colors: [AppConstants.primary, AppConstants.primaryContainer],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .frame(height: 260)

                            // Decorative oversized bee silhouette
                            HStack {
                                Spacer()
                                Image(systemName: "hexagon.fill")
                                    .font(.system(size: 180, weight: .ultraLight))
                                    .foregroundStyle(.white.opacity(0.1))
                                    .offset(x: 40, y: 40)
                            }

                            VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                                Image(systemName: "hexagon.fill")
                                    .font(.system(size: 36))
                                    .foregroundStyle(.white)
                                Text("Crown Bees")
                                    .font(.system(size: 38, weight: .bold))
                                    .tracking(-0.8)
                                    .foregroundStyle(.white)
                                Text("Your Mason Bee Companion")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                            .padding(.horizontal, AppConstants.Spacing.lg)
                            .padding(.bottom, AppConstants.Spacing.xl)
                        }

                        // MARK: - Login form on surfaceContainerLowest
                        VStack(spacing: AppConstants.Spacing.md) {

                            ghostField(placeholder: "Email", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()

                            ghostSecureField(placeholder: "Password", text: $password)

                            if !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            // Amber CTA
                            Button(action: login) {
                                Text("Log In")
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

                            // Register link
                            Button(action: { showRegister = true }) {
                                HStack(spacing: 4) {
                                    Text("Don't have an account?")
                                        .foregroundStyle(AppConstants.onSurfaceVariant)
                                    Text("Register")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(AppConstants.secondary)
                                }
                                .font(.subheadline)
                            }
                            .padding(.top, AppConstants.Spacing.xs)
                        }
                        .padding(AppConstants.Spacing.lg)
                        .background(AppConstants.surfaceContainerLowest)
                        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.lg))
                        .shadow(color: AppConstants.shadowColor.opacity(0.07), radius: 20, x: 0, y: 6)
                        .padding(.horizontal, AppConstants.Spacing.md)
                        .offset(y: -AppConstants.Spacing.xl)
                    }
                }
            }
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
        }
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
