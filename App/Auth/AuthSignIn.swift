import SwiftUI
import API
import UI

struct AuthSignIn: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var auth: AuthStore
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var form = AuthLoginRequest()
    
    enum Focus: CaseIterable { case email, password }
    @FocusState private var focus: Focus?
    
    @Sendable
    private func submit() async throws {
        if form.email.isEmpty {
            focus = .email
        } else if form.password.isEmpty {
            focus = .password
        } else if form.isValid {
            try await dispatch(AuthAction.login(form))
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("Email/name", text: $form.email)
                    #if canImport(UIKit)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    #endif
                    .autoFocus()
                    .textContentType(.username)
                    .focused($focus, equals: .email)
                
                SecureField("Password", text: $form.password)
                    .submitLabel(.done)
                    .focused($focus, equals: .password)
            }
            
            SubmitButton("Sign in")
                .disabled(!form.isValid)
            
            AuthContinueWith()
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
