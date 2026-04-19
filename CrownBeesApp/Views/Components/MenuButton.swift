import SwiftUI

struct MenuButton: View {
    @Binding var isMenuOpen: Bool

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                isMenuOpen.toggle()
            }
        }) {
            Image(systemName: isMenuOpen ? "xmark" : "line.3.horizontal")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(isMenuOpen ? AppConstants.surfaceContainerLowest : AppConstants.primary)
                .frame(width: 40, height: 40)
                .background(
                    isMenuOpen
                        ? AppConstants.primary
                        : AppConstants.primary.opacity(0.12)
                )
                .clipShape(Circle())
        }
    }
}
