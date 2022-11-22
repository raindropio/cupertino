import SwiftUI
import API
import UI
import AuthenticationServices

struct AuthScene: View {
    @EnvironmentObject private var auth: AuthStore
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    AuthViewEmail()
                } label: {
                    Label("Email", systemImage: "envelope")
                }
            }
                .navigationTitle("Welcome")
        }
    }
}

struct AuthViewEmail: View {
    @EnvironmentObject private var auth: AuthStore
    @EnvironmentObject private var dispatch: Dispatcher
    
    @State private var form = AuthLoginRequest()
    @State private var loading = false
    @State private var error: Error?
    
    enum Focus: CaseIterable { case email, password }
    @FocusState private var focus: Focus?
    
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
                    .focused($focus, equals: .email)
                
                SecureField("Password", text: $form.password)
                    .submitLabel(.done)
                    .focused($focus, equals: .password)
            }
        }
            #if os(macOS)
            .defaultFocus($focus, .email, priority: .userInitiated)
            #endif
            .safeAreaInset(edge: .bottom) {
                SubmitButton("Sign in")
                    .buttonStyle(.submit)
                    .controlSize(.large)
                    .padding()
                    .disabled(!form.isValid)
            }
            .disabled(loading)
//            .alert(error)
            .onSubmit {
                if form.password.isEmpty {
                    focus = .password
                } else if form.isValid {
                    Task {
                        loading = true
                        error = nil

                        do {
                            try await dispatch(AuthAction.login(form))
                        } catch {
                            self.error = error
                        }
                        
                        loading = false
                    }
                } else {
                    focus = .email
                }
            }
            .onAppear {
                focus = .email
            }
            .navigationTitle("Login")
            .animation(.default, value: loading)
            .animation(.default, value: form.isValid)
    }
}
