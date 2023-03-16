#if canImport(AppKit)
import SwiftUI
import UI
import Features

struct SettingsMacOS: View {
//    @State var path: SettingsPath

    var body: some View {
        //selection: $path.screen
        TabView {
            AuthGroup {
                SettingsLogout()
                    .tabItem { Label("Account", systemImage: "person.crop.circle") }
                    .tag(SettingsPath.Screen.account)
                
                SettingsSubscription()
                    .tabItem { Label("Subscription", systemImage: "bolt") }
                    .tag(SettingsPath.Screen.subscription)
            }
            
            SettingsExtensions()
                .tabItem { Label("Extensions", systemImage: "puzzlepiece.extension") }
                .tag(SettingsPath.Screen.extensions)
            
            AuthGroup {
                SettingsWebApp(subpage: .import)
                    .tabItem { Label("Import", systemImage: "square.and.arrow.down") }
                    .tag(SettingsPath.Screen.import)
                
                SettingsWebApp(subpage: .backups)
                    .tabItem { Label("Backups", systemImage: "clock.arrow.circlepath") }
                    .tag(SettingsPath.Screen.backups)
            }
        }
            .frame(width: 500)
            .fixedSize(horizontal: false, vertical: true)
    }
}
#endif
