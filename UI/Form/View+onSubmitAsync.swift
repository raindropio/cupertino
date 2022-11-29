import SwiftUI

public extension View {
    func onSubmit(_ action: @escaping (() async throws -> Void)) -> some View {
        modifier(OnSubmitAsync(action: action))
    }
}

fileprivate struct OnSubmitAsync: ViewModifier {
    @State private var submitting = false
    @State private var error: Error?
    
    var action: () async throws -> Void
    
    func submit() async throws {
        guard !submitting else { return }
        
        submitting = true
        
        do {
            try await action()
        } catch {
            self.error = error
        }
        
        submitting = false
    }
    
    func body(content: Content) -> some View {
        content
            .disabled(submitting)
            .environment(\.submitting, submitting)
            .animation(.easeInOut(duration: 0.2), value: submitting)
            .onSubmit {
                Task { try? await submit() }
            }
            .alert(
                "Error",
                isPresented: .init { error != nil } set: { if !$0 { error = nil } }
            ) { } message: {
                Text(error?.localizedDescription ?? "")
            }
    }
}

struct SubmittingKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    public var submitting: Bool {
        get {
            self[SubmittingKey.self]
        } set {
            if self[SubmittingKey.self] != newValue {
                self[SubmittingKey.self] = newValue
            }
        }
    }
}
