import SwiftUI
import UI
import API
import Backport

struct AuthTFA: ViewModifier {
    @StateObject private var service = Service()
    
    func body(content: Content) -> some View {
        Group {
            if let token = service.token {
                Stack(token: token)
            } else {
                content
                    .environmentObject(service)
            }
        }
            .animation(.default, value: service.token != nil)
    }
}

extension AuthTFA {
    class Service: ObservableObject {
        @Published var token: String?
        
        func callAsFunction(_ token: String) {
            self.token = token
        }
    }
}

extension AuthTFA {
    struct Stack: View {
        @Environment(\.dismiss) private var dismiss
        @EnvironmentObject private var dispatch: Dispatcher
        @FocusState private var focused: Bool
        @State private var code = ""

        var token: String
        
        var body: some View {
            NavigationStack {
                Form {
                    Section {
                        TextField("", text: $code, prompt: Text("Code"))
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 6)
                            .backport.focused($focused)
                    }
                    
                    SubmitButton("Continue")
                        .disabled(code.count != 6)
                    
                    Section {
                        SafariLink(role: .destructive, destination: URL(string: "https://app.raindrop.io/account/tfa/revoke/\(token)")!) {
                            Text("Can't access your 2FA device/app?").frame(maxWidth: .infinity)
                        }
                    }
                        .listRowBackground(Color.clear)
                }
                    .backport.scrollBounceBehavior(.basedOnSize)
                    .backport.defaultFocus($focused, true)
                    .autoSubmit(code.count == 6)
                    .onSubmit {
                        try await dispatch(AuthAction.tfa(token: token, code: code))
                        focused = true
                    }
                    .navigationTitle("Two-Factor Auth")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel", action: dismiss.callAsFunction)
                        }
                    }
            }
        }
    }
}
