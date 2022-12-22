import SwiftUI

public struct ConfirmButton<L: View, A: View> {
    @State private var confirm = false

    var role: ButtonRole?
    var message: String = ""
    var label: () -> L
    var actions: () -> A
    
    public init(
        message: String = "",
        role: ButtonRole? = nil,
        @ViewBuilder actions: @escaping () -> A,
        label: @escaping () -> L
    ) {
        self.message = message
        self.role = role
        self.label = label
        self.actions = actions
        self.confirm = false
    }
}

extension ConfirmButton where L == Text {
    public init<S>(
        _ title: S,
        message: String = "",
        role: ButtonRole? = nil,
        @ViewBuilder actions: @escaping () -> A
    ) where S : StringProtocol {
        self.label = {
            Text(title)
        }
        self.message = message
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
            ) {
                Text(message)
            }
    }
}
