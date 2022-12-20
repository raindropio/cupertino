import SwiftUI
import Backport

struct SettingsScene: View {
    @EnvironmentObject private var settings: SettingsRouter
    @AppStorage("theme") private var theme: PreferredTheme = .default

    var body: some View {
        Backport.NavigationStack(path: $settings.path) {
            SettingsHome()
                .backport.navigationDestination(for: SettingsRoute.self) {
                    switch $0 {
                    case .account:
                        SettingsWebApp(subpage: .account)
                    case .backups:
                        SettingsWebApp(subpage: .backups)
                    case .import:
                        SettingsWebApp(subpage: .import)
                    case .subscription:
                        SettingsSubscription()
                    }
                }
        }
            .preferredColorScheme(theme.colorScheme)
    }
}

extension SettingsScene {
    struct Attach: ViewModifier {
        @StateObject private var settings = SettingsRouter()
        
        func body(content: Content) -> some View {
            content
                .sheet(isPresented: $settings.isPresented) {
                    SettingsScene()
                }
                .environmentObject(settings)
        }
    }
}
