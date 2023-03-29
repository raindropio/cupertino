#if canImport(UIKit)
import SwiftUI
import UI

struct SettingsIOS: View {
    @State var path: SettingsPath

    var body: some View {
        NavigationSplitView {
            Sidebar(selection: $path.screen)
        } detail: {
            Group {
                switch path.screen {
                case .account:
                    SettingsAccount()
                case .backups:
                    SettingsWebApp(subpage: .backups)
                case .import:
                    SettingsWebApp(subpage: .import)
                case .subscription:
                    SettingsSubscription()
                case .appIcon:
                    SettingsAppIcon()
                case .extensions:
                    SettingsExtensions()
                case nil:
                    Color.clear
                }
            }
            .navigationBarTitleDisplayMode(.large)
        }
            .environment(\.horizontalSizeClass, .compact)
            .navigationBarTitleDisplayMode(.large)
    }
}
#endif
