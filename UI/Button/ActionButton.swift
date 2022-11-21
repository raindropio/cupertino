import SwiftUI

public struct ActionButton<Label: View> {
    @State private var loading = false
    @State private var error: Error?
    @State private var confirm = false
    
    var role: ButtonRole?
    var action: () async throws -> Void
    var label: () -> Label
    
    public init(
        role: ButtonRole? = nil,
        action: @escaping () async throws -> Void,
        label: @escaping () -> Label
    ) {
        self.role = role
        self.action = action
        self.label = label
        self.confirm = false
    }
}

extension ActionButton where Label == Text {
    public init<S>(
        _ title: S,
        role: ButtonRole? = nil,
        action: @escaping () async throws -> Void
    ) where S : StringProtocol {
        self.label = {
            Text(title)
        }
        self.role = role
        self.action = action
        self.confirm = false
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
    public var body: some View {
        Button(role: role) {
            if role == .destructive {
                confirm = true
            } else {
                Task { await press() }
            }
        } label: {
            ZStack {
                label()
                    .opacity(loading ? 0 : 1)
                
                if loading {
                    ProgressView().progressViewStyle(.circular)
                }
            }
        }
            .disabled(loading)
            .animation(.easeInOut(duration: 0.2), value: loading)
            .confirmationDialog("Are you sure?", isPresented: $confirm) {
                Button(role: .destructive) {
                    Task { await press() }
                } label: {
                    label()
                }
            }
            .alert(
                "Error",
                isPresented: .init { error != nil } set: { if !$0 { error = nil } }
            ) { } message: {
                Text(error?.localizedDescription ?? "")
            }
    }
}
