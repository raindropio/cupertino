import SwiftUI
import API
import UI
import Backport
import Common

struct SettingsHome: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section {
                Backport.NavigationLink(value: SettingsRoute.account) {
                    MeLabel()
                }
                
                Backport.NavigationLink(value: SettingsRoute.subscription) {
                    Label("Subscription", systemImage: "bolt.fill")
                        .badge("Monthly")
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
                    Label("Integrations", systemImage: "puzzlepiece.extension.fill").badge("+2,000").tint(.primary)
                }
                    .listItemTint(.purple)
                
                Backport.NavigationLink(value: SettingsRoute.import) {
                    Label("Import", systemImage: "square.and.arrow.down.fill").tint(.primary)
                }
                    .listItemTint(.orange)
                
                Backport.NavigationLink(value: SettingsRoute.backups) {
                    Label("Backups", systemImage: "clock.arrow.circlepath").tint(.primary)
                }
                    .listItemTint(.brown)
            }
            
            Section {
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
            .navigationTitle("Settings")
            .labelStyle(.settings)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: dismiss.callAsFunction)
                }
            }
    }
}
