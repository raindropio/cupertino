import SwiftUI

#if canImport(UIKit)
struct FixEditModeModifier: ViewModifier {
    @Environment(\.editMode) private var em
    @State private var editMode = EditMode.inactive
    
    func body(content: Content) -> some View {
        content
            .environment(\.editMode, $editMode)
            .task(id: em?.wrappedValue, debounce: 0.1) {
                withAnimation {
                    editMode = em?.wrappedValue ?? .inactive
                }
            }
    }
}

public extension View {
    /// On iPad when share sheet is presented editMode is reseted to inactive, usually breaking List selection state
    @ViewBuilder
    func fixEditMode() -> some View {
        if isPhone {
            self
        } else {
            modifier(FixEditModeModifier())
        }
    }
}
#endif
