import SwiftUI

#if os(iOS)
struct SettingsIndex: View {
    var body: some View {
        Section {
            NavigationLink(value: SettingsPage.account) {
                Label(SettingsPage.account.label, systemImage: SettingsPage.account.systemImage)
                    .tint(.red)
            }
            
            NavigationLink(value: SettingsPage.subscription) {
                Label(SettingsPage.subscription.label, systemImage: SettingsPage.subscription.systemImage)
                    .tint(.indigo)
            }
        }
        
        Section {
            NavigationLink(value: SettingsPage.general) {
                Label(SettingsPage.general.label, systemImage: SettingsPage.general.systemImage)
                    .tint(.gray)
            }
            
            NavigationLink(value: SettingsPage.import) {
                Label(SettingsPage.import.label, systemImage: SettingsPage.import.systemImage)
            }
            
            NavigationLink(value: SettingsPage.backups) {
                Label(SettingsPage.backups.label, systemImage: SettingsPage.backups.systemImage)
                    .tint(.brown)
            }
        }
        
        Section {
            NavigationLink(value: SettingsPage.about) {
                Label(SettingsPage.about.label, systemImage: SettingsPage.about.systemImage)
            }
        }
    }
}
#endif
