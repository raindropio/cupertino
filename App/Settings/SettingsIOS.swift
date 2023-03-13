import SwiftUI
import UI

#if os(iOS)
struct SettingsIOS: View {
    @State var path: SettingsPath

    var body: some View {
        NavigationStack(path: $path.screen) {
            SettingsHome()
                .navigationDestination(for: SettingsPath.Screen.self) {
                    switch $0 {
                    case .account:
                        SettingsWebApp(subpage: .account)
                    case .backups:
                        SettingsWebApp(subpage: .backups)
                    case .import:
                        SettingsWebApp(subpage: .import)
                    case .subscription:
                        SettingsSubscription()
                    case .appearance:
                        SettingsAppearance()
                    case .extensions:
                        SettingsExtensions()
                    }
                }
        }
    }
}
#endif
