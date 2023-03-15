#if canImport(AppKit)
import SwiftUI
import UI

struct SettingsMacOS: View {
//    @State var path: SettingsPath

    var body: some View {
        //selection: $path.screen
        TabView {
            SettingsLogout()
                .tabItem { Label("Account", systemImage: "person.crop.circle") }
                .tag(SettingsPath.Screen.account)
            
            SettingsSubscription()
                .tabItem { Label("Subscription", systemImage: "bolt") }
                .tag(SettingsPath.Screen.subscription)
            
            SettingsAppearance()
                .tabItem { Label("Appearance", systemImage: "square.on.circle") }
                .tag(SettingsPath.Screen.appearance)
            
            SettingsExtensions()
                .tabItem { Label("Extensions", systemImage: "puzzlepiece.extension") }
                .tag(SettingsPath.Screen.extensions)
            
            SettingsWebApp(subpage: .import)
                .tabItem { Label("Import", systemImage: "square.and.arrow.down") }
                .tag(SettingsPath.Screen.import)
            
            SettingsWebApp(subpage: .backups)
                .tabItem { Label("Backups", systemImage: "clock.arrow.circlepath") }
                .tag(SettingsPath.Screen.backups)
        }
            .frame(width: 500)
            .fixedSize(horizontal: false, vertical: true)
    }
}
#endif
