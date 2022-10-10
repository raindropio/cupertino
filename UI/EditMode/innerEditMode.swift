import SwiftUI

#if os(iOS)
struct InnerEditModeModifier: ViewModifier {
    @Environment(\.editMode) private var editMode
    var action: (EditMode) -> Void
    
    func body(content: Content) -> some View {
        content
            .task(id: editMode?.wrappedValue) {
                if let editMode = editMode?.wrappedValue {
                    action(editMode)
                }
            }
    }
}

public extension View {
    func innerEditMode(_ action: @escaping (EditMode) -> Void) -> some View {
        modifier(InnerEditModeModifier(action: action))
    }
}
#endif
