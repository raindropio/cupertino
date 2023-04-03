import SwiftUI
import UI
import API
import Backport

struct AuthTFA: ViewModifier {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var show = false
    @FocusState private var focused: Bool
    @State private var code = ""
    
    var token: String?
    
    func body(content: Content) -> some View {
        content
            .task(id: token) {
                show = token != nil
                code = ""
            }
            .sheet(isPresented: $show) {
                NavigationStack {
                    Form {
                        Section("Authenticator app code") {
                            TextField("", text: $code)
                                .textContentType(.oneTimeCode)
                                .keyboardType(.numberPad)
                                .backport.focused($focused)
                        }
                        
                        SubmitButton("Login")
                            .disabled(code.isEmpty)
                    }
                        .backport.defaultFocus($focused, true)
                        .backport.scrollBounceBehavior(.basedOnSize)
                        .navigationTitle("2FA")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") { show = false }
                            }
                            
                            ToolbarItem {
                                if let token {
                                    SafariLink("Disable", destination: URL(string: "https://app.raindrop.io/account/tfa/revoke/\(token)")!)
                                }
                            }
                            
                            ToolbarItem {
                                SafariLink("Help", destination: URL(string: "https://help.raindrop.io/tfa")!)
                            }
                        }
                        .onSubmit {
                            if let token {
                                try await dispatch(AuthAction.tfa(token: token, code: code))
                            }
                        }
                }
                    .presentationDetents([.fraction(0.333)])
            }
    }
}
