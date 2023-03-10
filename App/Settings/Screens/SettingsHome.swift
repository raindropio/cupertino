import SwiftUI
import API
import UI
import Features

struct SettingsHome: View {
    @EnvironmentObject private var s: SubscriptionStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Group {
                Section {
                    NavigationLink(value: SettingsRoute.account) {
                        MeLabel()
                    }
                    
                    NavigationLink(value: SettingsRoute.subscription) {
                        Label("Subscription", systemImage: "bolt")
                            .badge(s.state.current?.plan.title ?? "Free")
                            .tint(.primary)
                    }
                        .listItemTint(.red)
                }
                
                Section {
                    NavigationLink(value: SettingsRoute.extensions) {
                        Label("Extensions", systemImage: "puzzlepiece.extension").tint(.primary)
                    }
                        .listItemTint(.purple)
                    
                    NavigationLink(value: SettingsRoute.appearance) {
                        Label("Appearance", systemImage: "square.on.circle").tint(.primary)
                    }
                        .listItemTint(.indigo)
                    
                    SettingsBrowser()
                        .listItemTint(.cyan)
                }
                
                Section {
                    Link(destination: URL(string: "https://ifttt.com/raindrop")!) {
                        Label("Integrations", systemImage: "puzzlepiece.extension").badge("+2,000").tint(.primary)
                    }
                    
                    NavigationLink(value: SettingsRoute.import) {
                        Label("Import", systemImage: "square.and.arrow.down").tint(.primary)
                    }
                    
                    NavigationLink(value: SettingsRoute.backups) {
                        Label("Backups", systemImage: "clock.arrow.circlepath").tint(.primary)
                    }
                    
                    SafariLink(destination: URL(string: "https://raindrop.io/download")!) {
                        Label("Desktop app", systemImage: "desktopcomputer").tint(.primary)
                    }
                    
                    SafariLink(destination: URL(string: "https://help.raindrop.io/")!) {
                        Label("Help", systemImage: "questionmark.circle").tint(.primary)
                    }
                } footer: {
                    Text("Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""))")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .scenePadding(.top)
                }
                    .listItemTint(.monochrome)
                
                SettingsLogout()
            }
                .environment(\.defaultMinListRowHeight, 40)
        }
            .safeAreaInset(edge: .top) { Color.clear.frame(height: 4) }
            .navigationTitle("Settings")
            .labelStyle(.sidebar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: dismiss.callAsFunction)
                }
            }
    }
}
