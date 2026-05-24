import SwiftUI

struct PLPanel<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        if #available(macOS 26.0, *) {
            panelContent
                .glassEffect(
                    .regular.interactive(true),
                    in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                )
        } else {
            panelContent
        }
    }

    private var panelContent: some View {
        content
            .padding(10)
            .frame(maxWidth: .infinity)
            .background {
                if #available(macOS 26.0, *) {
                    Color.clear
                } else {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.regularMaterial)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(.separator.opacity(0.35), lineWidth: 0.5)
            }
    }
}
