import SwiftUI

public struct ActionButton<L: View> {
    @State private var loading = false
    @State private var error: Error?
    
    var role: ButtonRole?
    var confirm: Bool = false
    var message: String = ""
    var action: () async throws -> Void
    var label: () -> L
    
    public init(
        message: String = "",
        role: ButtonRole? = nil,
        confirm: Bool? = nil,
        action: @escaping () async throws -> Void,
        @ViewBuilder label: @escaping () -> L
    ) {
        self.message = message
        self.role = role
        self.confirm = confirm ?? (role == .destructive)
        self.action = action
        self.label = label
    }
}

extension ActionButton where L == Text {
    public init<S>(
        _ title: S,
        message: String = "",
        role: ButtonRole? = nil,
        confirm: Bool? = nil,
        action: @escaping () async throws -> Void
    ) where S : StringProtocol {
        self.message = message
        self.label = {
            Text(title)
        }
        self.role = role
        self.confirm = confirm ?? (role == .destructive)
        self.action = action
    }
}

extension ActionButton {
    func press() async {
        do {
            loading = true
            defer { loading = false }
            try await action()
        } catch {
            self.error = error
        }
    }
}

extension ActionButton: View {
    func button() -> some View {
        Button(
            role: role,
            action: {
                Task { await press() }
            },
            label: status
        )
    }
    
    func status() -> some View {
        ZStack {
            label()
                .opacity(loading ? 0 : 1)
            
            if loading {
                ProgressView()
            }
        }
    }
    
    public var body: some View {
        Group {
            if confirm {
                ConfirmButton(message: message, role: role, actions: button, label: status)
            } else {
                button()
            }
        }
            .disabled(loading)
            .safeAnimation(.easeInOut(duration: 0.2), value: loading)
            .alert(
                "Error",
                isPresented: .init { error != nil } set: { if !$0 { error = nil } }
            ) { } message: {
                Text(error?.localizedDescription ?? "")
            }
    }
}
