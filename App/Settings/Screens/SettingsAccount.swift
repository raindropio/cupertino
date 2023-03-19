import SwiftUI
import API
import UI

struct SettingsAccount: View {
    @EnvironmentObject private var u: UserStore
    @EnvironmentObject private var dispatch: Dispatcher

    var body: some View {
        Form {
            if let me = u.state.me {
                Section {
                    LabeledContent("Username", value: me.name)
                    LabeledContent("Email", value: me.email)
                    LabeledContent("ID", value: me.id, format: .number)
                    LabeledContent("Member since", value: me.registered, format: .dateTime)
                }
                
                Section {
                    SafariLink(destination: URL(string: "https://app.raindrop.io/settings/account")!) {
                        Text("Edit").frame(maxWidth: .infinity)
                    }
                    
                    ActionButton(role: .destructive) {
                        try await dispatch(AuthAction.logout)
                    } label: {
                        Text("Logout").frame(maxWidth: .infinity)
                    }
                        .tint(.red)
                }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                    .buttonStyle(.borderless)
            } else {
                Text("Not logged in")
            }
        }
            .navigationTitle("Account")
    }
}
