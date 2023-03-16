import SwiftUI
import API
import UI
import Backport

struct AuthLogIn: View {
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
                TextField("Email", text: $form.email)
                    #if canImport(UIKit)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .textContentType(.username)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    #endif
                    .backport.focused($focus, equals: .email)
                
                SecureField("Password", text: $form.password)
                    .submitLabel(.done)
                    .backport.focused($focus, equals: .password)
            }
            
            SubmitButton("Sign in")
                .disabled(!form.isValid)
            
            AuthContinueWith()
                .opacity(form.isEmpty ? 1 : 0)
                .animation(.default, value: form.isEmpty)
        }
            .backport.defaultFocus($focus, .email)
            .onSubmit(submit)
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Welcome back")
            #else
            .formStyle(.columns)
            .textFieldStyle(.roundedBorder)
            .controlSize(.large)
            .scenePadding()
            #endif
            .toolbar {
                ToolbarItem {
                    SafariLink("Forgot?", destination: URL(string: "https://app.raindrop.io/account/lost")!)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: dismiss.callAsFunction)
                }
            }
    }
}
