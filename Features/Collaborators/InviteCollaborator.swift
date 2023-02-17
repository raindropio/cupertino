import SwiftUI
import API
import UI

struct InviteCollaborator: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var request = InviteCollaboratorRequest(level: .member)
    @State private var send = false
    
    @Binding var collection: UserCollection
    
    @Sendable
    private func submit() async throws {
        guard request.isValid else { return }
        try await dispatch(CollaboratorsAction.invite(collection.id, request))
        send = true
    }
    
    var body: some View {
        Form {
            if send {
                EmptyState(
                    "Invite is send to \(request.email)",
                    message: "Person need to click on the link from the email, and after a while, the shared collection become available on account"
                ) {
                    Image(systemName: "envelope")
                        .foregroundColor(.green)
                } actions: {
                    Button("Invite more") {
                        request = .init(level: request.level)
                        send = false
                    }
                        .buttonStyle(.borderless)
                }
            } else {
                Section {
                    TextField("Email", text: $request.email)
                        #if canImport(UIKit)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .submitLabel(.send)
                        #endif
                        .autoFocus()
                }
                
                Section("Access level") {
                    Picker(selection: $request.level) {
                        Text(CollectionAccess.Level.member.title)
                            .tag(CollectionAccess.Level.member)
                        Text(CollectionAccess.Level.viewer.title)
                            .tag(CollectionAccess.Level.viewer)
                    } label: {}
                        .pickerStyle(.inline)
                }
                
                SubmitButton("Send invite")
                    .disabled(!request.isValid)
            }
        }
            .onSubmit(submit)
            .navigationTitle("Invite")
            .animation(.default, value: request.isValid)
            .animation(.default, value: send)
    }
}
