import SwiftUI
import API
import UI
import Backport

struct AuthSignIn: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var auth: AuthStore
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var form = AuthLoginRequest()
    
    enum Focus: CaseIterable { case email, password }
    @FocusState private var focus: Focus?
    
    @Sendable
    private func submit() async throws {
        if form.password.isEmpty {
            focus = .password
        } else if form.isValid {
            try await dispatch(AuthAction.login(form))
        } else {
            focus = .email
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("Email/name", text: $form.email)
                    #if canImport(UIKit)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .textContentType(.username)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    #endif
                    .autoFocus()
                    .focused($focus, equals: .email)
                
                SecureField("Password", text: $form.password)
                    .submitLabel(.done)
                    .focused($focus, equals: .password)
            }
            
            SubmitButton("Sign in")
                .disabled(!form.isValid)
        }
            .onSubmit(submit)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(systemName: "person.badge.key.fill")
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: dismiss.callAsFunction)
                }
            }
    }
}
