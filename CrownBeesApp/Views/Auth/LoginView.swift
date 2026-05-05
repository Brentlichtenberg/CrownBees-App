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
                forestGreenBackground
                ScrollView {
                    VStack(spacing: 0) {
                        heroSection
                        loginCard
                    }
                }
            }
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }

    // MARK: - Subviews

    private var forestGreenBackground: some View {
        LinearGradient(
            colors: [Color(hex: "#1a3d2a"), Color(hex: "#4a7c5a")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            HStack {
                Spacer()
                Image(systemName: "hexagon.fill")
                    .font(.system(size: 180, weight: .ultraLight))
                    .foregroundStyle(.white.opacity(0.07))
                    .offset(x: 40, y: 40)
            }
            VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                Image(systemName: "hexagon.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(AppConstants.primary)
                Text("Crown Bees")
                    .font(.system(size: 38, weight: .bold))
                    .tracking(-0.8)
                    .foregroundStyle(.white)
                Text("Your Solitary Bee Companion")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.75))
            }
            .padding(.horizontal, AppConstants.Spacing.lg)
            .padding(.vertical, AppConstants.Spacing.xxl)
        }
    }

    private var loginCard: some View {
        GlassEffectContainer {
            VStack(spacing: AppConstants.Spacing.md) {
                GlassInputField(placeholder: "Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()

                GlassInputField(placeholder: "Password", text: $password, isSecure: true)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                amberCTAButton(label: "Log In", action: login)

                Button(action: { showRegister = true }) {
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundStyle(.white.opacity(0.7))
                        Text("Register")
                            .fontWeight(.semibold)
                            .foregroundStyle(AppConstants.primary)
                    }
                    .font(.subheadline)
                }
                .padding(.top, AppConstants.Spacing.xs)
            }
            .padding(AppConstants.Spacing.lg)
            .glassEffect(in: .rect(cornerRadius: AppConstants.Radius.lg))
        }
        .padding(.horizontal, AppConstants.Spacing.md)
        .offset(y: -AppConstants.Spacing.xl)
    }

    // MARK: - Helpers

    @ViewBuilder
    private func amberCTAButton(label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
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
