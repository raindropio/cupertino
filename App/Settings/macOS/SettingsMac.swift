import SwiftUI

#if os(macOS)
struct SettingsMac: View {
    @EnvironmentObject private var settings: SettingsService
    
    var body: some View {
        TabView {
            Text("")
                .tabItem {
                    Label(SettingsPage.general.label, systemImage: SettingsPage.general.systemImage)
                }
            
            SettingsAccount()
                .tabItem {
                    Label(SettingsPage.account.label, systemImage: SettingsPage.account.systemImage)
                }
            
            Text("")
                .tabItem {
                    Label(SettingsPage.subscription.label, systemImage: SettingsPage.subscription.systemImage)
                }
            
            Text("")
                .tabItem {
                    Label(SettingsPage.import.label, systemImage: SettingsPage.import.systemImage)
                }
            
            Text("")
                .tabItem {
                    Label(SettingsPage.backups.label, systemImage: SettingsPage.backups.systemImage)
                }
        }
        .frame(minWidth: 400, minHeight: 400)
    }
}
#endif
