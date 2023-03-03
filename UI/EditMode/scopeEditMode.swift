#if os(iOS)
import SwiftUI

public extension View {
    /// Prevents leaking `editMode` inside specific view hierarchy
    /// Helps fix issues with SplitView for example
    func scopeEditMode() -> some View {
        modifier(_ScopeEditMode())
    }
}

fileprivate struct _ScopeEditMode: ViewModifier {
    @State private var editMode = EditMode.inactive
    
    func body(content: Content) -> some View {
        content.environment(\.editMode, $editMode)
    }
}
#endif
