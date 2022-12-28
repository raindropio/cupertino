import SwiftUI

public extension View {
    /// Makes `editMode` inside specific view hierarchy independend
    /// Helps fix issues with SplitView for example
    func detachedEditMode() -> some View {
        modifier(_DetachedEditMode())
    }
}

fileprivate struct _DetachedEditMode: ViewModifier {
    @State private var editMode = EditMode.inactive
    
    func body(content: Content) -> some View {
        content
            .environment(\.editMode, $editMode)
    }
}
