import SwiftUI
import API
import UI
import Features
import Backport

struct SettingsAccount: View {
    @EnvironmentObject private var u: UserStore
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var edit: SettingsWebApp.Subpage?

    var body: some View {
        Form {
            if let me = u.state.me {
                Section {
                    LabeledContent("Username", value: me.name).textSelection(.enabled)
                    LabeledContent("Email", value: me.email).textSelection(.enabled)
                    LabeledContent("ID", value: "\(me.id)").textSelection(.enabled)
                    LabeledContent("Registered", value: me.registered, format: .relative(presentation: .named))
                } header: {
                    UserAvatar(me, width: 72)
                        .frame(maxWidth: .infinity)
                        .scenePadding(.bottom)
                }
                
                if me.tfa.enabled {
                    Section {
                        Button("Manage Two-Factor Authentication") {
                            edit = .tfa
                        }
                    }
                }
                
                ControlGroup {
                    Button("Edit") {
                        edit = .account
                    }

                    ActionButton("Logout", role: .destructive, confirm: false) {
                        try await dispatch(AuthAction.logout)
                    }
                }
                    .controlGroupStyle(.horizontal)
            } else {
                Text("Not logged in")
            }
        }
            .navigationTitle("Account")
            .refreshable {
                try? await dispatch(UserAction.reload)
            }
            .reload {
                try? await dispatch(UserAction.reload)
            }
            .sheet(item: $edit) { subpage in
                NavigationStack {
                    SettingsWebApp(subpage: subpage)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") { edit = nil }
                            }
                        }
                }
            }
    }
}
