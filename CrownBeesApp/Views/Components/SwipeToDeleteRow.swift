import SwiftUI

struct SwipeToDeleteRow<Content: View>: View {
    let content: () -> Content
    let onDelete: () -> Void

    @State private var offset: CGFloat = 0
    @State private var isRevealed = false

    private let deleteWidth: CGFloat = 80

    var body: some View {
        ZStack(alignment: .trailing) {
            // Delete button — stays in place; exposed when content slides left
            Button {
                onDelete()
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Delete")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(.white)
                .frame(width: deleteWidth)
                .frame(maxHeight: .infinity)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))
            }

            // Content wrapper with opaque backing — prevents red button from
            // bleeding through the transparent glass row background at rest
            ZStack {
                RoundedRectangle(cornerRadius: AppConstants.Radius.md)
                    .fill(Color(hex: "#1a3d2a"))
                content()
            }
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))
            .offset(x: offset)
            .onTapGesture {
                if isRevealed { closeSwipe() }
            }
            .gesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { value in
                        let dx = value.translation.width
                        let base: CGFloat = isRevealed ? -deleteWidth : 0
                        withAnimation(.interactiveSpring()) {
                            offset = min(max(base + dx, -deleteWidth), 0)
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            if value.translation.width < -(deleteWidth / 2) {
                                offset = -deleteWidth
                                isRevealed = true
                            } else {
                                offset = 0
                                isRevealed = false
                            }
                        }
                    }
            )
        }
        .clipped()
    }

    private func closeSwipe() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            offset = 0
            isRevealed = false
        }
    }
}
