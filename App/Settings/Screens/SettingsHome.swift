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
                    SettingsBrowser()
                        .listItemTint(.blue)
                    
                    SettingsTheme()
                        .listItemTint(.indigo)
                    
                    Link(destination: URL(string: "https://ifttt.com/raindrop")!) {
                        Label("Integrations", systemImage: "puzzlepiece.extension").badge("+2,000").tint(.primary)
                    }
                        .listItemTint(.purple)
                    
                    NavigationLink(value: SettingsRoute.import) {
                        Label("Import", systemImage: "square.and.arrow.down").tint(.primary)
                    }
                        .listItemTint(.orange)
                    
                    NavigationLink(value: SettingsRoute.backups) {
                        Label("Backups", systemImage: "clock.arrow.circlepath").tint(.primary)
                    }
                        .listItemTint(.brown)
                }
                
                Section {
                    SafariLink(destination: URL(string: "https://raindrop.io/download")!) {
                        Label("Desktop app", systemImage: "desktopcomputer").tint(.primary)
                    }
                        .listItemTint(.gray)
                    
                    SafariLink(destination: URL(string: "https://help.raindrop.io/")!) {
                        Label("Help", systemImage: "questionmark.circle").tint(.primary)
                    }
                        .listItemTint(.gray)
                    
                    Link(destination: URL(string: "mailto:info@raindrop.io")!) {
                        Label("Support", systemImage: "square.and.pencil").tint(.primary)
                    }
                        .listItemTint(.gray)
                }
                
                SettingsLogout()
                
                Section {} footer: {
                    Text("Version \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }
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
