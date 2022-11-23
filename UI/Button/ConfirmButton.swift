import SwiftUI

public struct ConfirmButton<L: View, A: View> {
    @State private var confirm = false

    var role: ButtonRole?
    var label: () -> L
    var actions: () -> A
    
    public init(
        role: ButtonRole? = nil,
        @ViewBuilder actions: @escaping () -> A,
        label: @escaping () -> L
    ) {
        self.role = role
        self.label = label
        self.actions = actions
        self.confirm = false
    }
}

extension ConfirmButton where L == Text {
    public init<S>(
        _ title: S,
        role: ButtonRole? = nil,
        @ViewBuilder actions: @escaping () -> A
    ) where S : StringProtocol {
        self.label = {
            Text(title)
        }
        self.role = role
        self.actions = actions
        self.confirm = false
    }
}

extension ConfirmButton: View {
    public var body: some View {
        Button(
            role: role,
            action: { confirm = true },
            label: label
        )
            .confirmationDialog(
                "Are you sure?",
                isPresented: $confirm,
                titleVisibility: .visible,
                actions: actions
            )
    }
}
