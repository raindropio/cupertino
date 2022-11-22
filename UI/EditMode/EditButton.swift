import SwiftUI

#if os(iOS)
public struct EditButton<L> : View where L : View {
    @Environment(\.editMode) private var editMode
    var label: (EditMode) -> L
    
    public init(_ label: @escaping (EditMode) -> L) {
        self.label = label
    }
    
    public init(_ label: @escaping () -> L) {
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

extension EditButton where L == Label<Text, Image> {
    public init<S>(_ title: S) where S : StringProtocol {
        self.label = { _ in
            Label(title, systemImage: "checkmark.circle")
        }
    }
}
#endif
