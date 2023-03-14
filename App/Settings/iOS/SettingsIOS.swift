#if canImport(UIKit)
import SwiftUI
import UI

struct SettingsIOS: View {
    @State var path: SettingsPath

    var body: some View {
        NavigationSplitView {
            Sidebar(selection: $path.screen)
        } detail: {
            switch path.screen {
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
            case nil:
                Color.clear
            }
        }
            .environment(\.horizontalSizeClass, .compact)
    }
}
#endif
