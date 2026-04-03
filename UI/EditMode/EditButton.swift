import SwiftUI

#if canImport(UIKit)
public struct EditButton<L> : View where L : View {
    @Environment(\.editMode) private var editMode
    var label: (EditMode) -> L
    
    public init(@ViewBuilder _ label: @escaping (EditMode) -> L) {
        self.label = label
    }
    
    public init(@ViewBuilder _ label: @escaping () -> L) {
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
    public init(_ title: LocalizedStringKey) {
        self.label = { _ in
            Label { Text(title, bundle: .main) } icon: { Image(systemName: "checkmark.circle") }
        }
    }
}
#endif
