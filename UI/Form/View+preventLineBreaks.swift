import SwiftUI

public extension View {
    func preventLineBreaks(text: Binding<String>) -> some View {
        modifier(PreventLineBreaksModifier(text: text))
    }
}

struct PreventLineBreaksModifier: ViewModifier {
    @Environment(\.onSubmitAction) private var onSubmitAction
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .onChange(of: text) {
                if $0.contains("\n") {
                    text = text.replacingOccurrences(of: "\n", with: "")
                    onSubmitAction()
                }
            }
            .transaction { $0.animation = nil }
    }
}
