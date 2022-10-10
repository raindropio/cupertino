import SwiftUI

#if os(iOS)
public struct EditButton<Label> : View where Label : View {
    @Environment(\.editMode) private var editMode
    var label: (EditMode) -> Label
    
    public init(_ label: @escaping (EditMode) -> Label) {
        self.label = label
    }
    
    public init(_ label: @escaping () -> Label) {
        self.label = { _ in label() }
    }
    
    public var body: some View {
        Button {
            withAnimation {
                if editMode?.wrappedValue == .inactive {
                    editMode?.wrappedValue = .active
                } else {
                    editMode?.wrappedValue = .inactive
                }
            }
        } label: {
            label(editMode?.wrappedValue ?? .inactive)
        }
    }
}
#endif
