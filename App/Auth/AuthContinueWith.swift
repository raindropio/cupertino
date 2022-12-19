import SwiftUI
import AuthenticationServices
import UI
import API
import Backport

struct AuthContinueWith {
    @EnvironmentObject private var a: AuthStore
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var loading = false
    @State private var error: Error?
}

extension AuthContinueWith {
    private func process(_ action: AuthAction) {
        Task {
            loading = true
            do {
                try await dispatch(action)
            } catch {
                self.error = error
            }
            loading = false
        }
    }
}

//MARK: View
extension AuthContinueWith: View {
    var body: some View {
        Section {
            HStack(spacing: 16) {
                Apple(action: process)
                JWT(action: process)
            }
        }
            .clearSection()
            .disabled(loading)
            .animation(.easeInOut(duration: 0.2), value: loading)
            .alert(
                "Error",
                isPresented: .init { error != nil } set: { if !$0 { error = nil } }
            ) { } message: {
                Text(error?.localizedDescription ?? "")
            }
    }
}
