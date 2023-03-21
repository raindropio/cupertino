import SwiftUI
import API
import UI
import Features

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
                } header: {
                    UserAvatar(me, width: 72)
                        .frame(maxWidth: .infinity)
                        .scenePadding(.bottom)
                }
                
                ControlGroup {
                    SafariLink("Edit", destination: URL(string: "https://app.raindrop.io/settings/account")!)
                    ActionButton("Logout", role: .destructive) {
                        try await dispatch(AuthAction.logout)
                    }
                }
                    .controlGroupStyle(.horizontal)
            } else {
                Text("Not logged in")
            }
        }
            .navigationTitle("Account")
    }
}
