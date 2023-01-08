import SwiftUI

public extension View {
    func dismissOnSearchCancel() -> some View {
        modifier(DismissOnSearchCancel())
    }
}

fileprivate struct DismissOnSearchCancel: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isSearching) private var isSearching
        
    func body(content: Content) -> some View {
        content
            .onChange(of: isSearching) {
                if !$0 {
                    dismiss()
                }
            }
    }
}
