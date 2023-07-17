import SwiftUI
import AuthenticationServices
import UI
import API

struct AuthContinueWith {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var a: AuthStore
    @EnvironmentObject private var dispatch: Dispatcher
    @EnvironmentObject private var tfa: AuthTFA.Service
    @State private var loading = false
    @State private var error: Error?
}

extension AuthContinueWith {
    private func process(_ action: AuthAction) {
        Task {
            loading = true
            do {
                try await dispatch(action)
            } catch RestError.tfaRequired(let token) {
                tfa(token)
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
            VStack(spacing: 12) {
                Group {
                    Apple(action: process)
                    Google(action: process)
                    JWT(action: process)
                }
                .frame(height: 45)
            }
        } header: {
            HStack(spacing: 24) {
                VStack { Divider() }.frame(maxWidth: .infinity)
                Text("Or")
                VStack { Divider() }.frame(maxWidth: .infinity)
            }
                .padding(.vertical)
                .padding(.bottom)
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
