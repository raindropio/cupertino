import SwiftUI
import API

extension Spotlight {
    struct Cancel: ViewModifier {
        @EnvironmentObject private var event: SpotlightEvent
        @Environment(\.isSearching) private var isSearching
        
        @Binding var focused: Bool
        
        func body(content: Content) -> some View {
            content
                .onChange(of: isSearching) {
                    if !$0 {
                        event.press(.cancel)
                        Task { focused = true }
                    }
                }
        }
    }
}
