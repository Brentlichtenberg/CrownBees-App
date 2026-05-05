import SwiftUI

/// Shared glass text/secure field for iOS 26 Liquid Glass forms.
struct GlassInputField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var isMultiline: Bool = false
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else if isMultiline {
                TextField(placeholder, text: $text, axis: .vertical)
                    .lineLimit(3...6)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
            }
        }
        .padding(AppConstants.Spacing.md)
        .glassEffect(in: .rect(cornerRadius: AppConstants.Radius.md))
    }
}
