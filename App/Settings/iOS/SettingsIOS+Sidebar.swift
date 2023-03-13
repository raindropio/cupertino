import SwiftUI
import API
import UI
import Features

extension SettingsIOS {
    struct Sidebar: View {
        @EnvironmentObject private var s: SubscriptionStore
        @Environment(\.dismiss) private var dismiss
        
        @Binding var selection: SettingsPath.Screen?
        
        var body: some View {
            List(selection: $selection) {
                Group {
                    Section {
                        NavigationLink(value: SettingsPath.Screen.account) {
                            MeLabel()
                        }
                        
                        NavigationLink(value: SettingsPath.Screen.subscription) {
                            Label("Subscription", systemImage: "bolt")
                                .badge(s.state.current?.plan.title ?? "Free")
                                .tint(.primary)
                        }
                        .listItemTint(.red)
                    }
                    
                    Section {
                        NavigationLink(value: SettingsPath.Screen.extensions) {
                            Label("Extensions", systemImage: "puzzlepiece.extension").tint(.primary)
                        }
                        .listItemTint(.purple)
                        
                        NavigationLink(value: SettingsPath.Screen.appearance) {
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
                        
                        NavigationLink(value: SettingsPath.Screen.import) {
                            Label("Import", systemImage: "square.and.arrow.down").tint(.primary)
                        }
                        
                        NavigationLink(value: SettingsPath.Screen.backups) {
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
            .listStyle(.insetGrouped)
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
}
