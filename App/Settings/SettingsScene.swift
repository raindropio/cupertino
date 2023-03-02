import SwiftUI
import UI

struct SettingsScene: View {
    @EnvironmentObject private var settings: SettingsRouter

    var body: some View {
        NavigationStack(path: $settings.path) {
            SettingsHome()
                .navigationDestination(for: SettingsRoute.self) {
                    switch $0 {
                    case .account:
                        SettingsWebApp(subpage: .account)
                    case .backups:
                        SettingsWebApp(subpage: .backups)
                    case .import:
                        SettingsWebApp(subpage: .import)
                    case .subscription:
                        SettingsSubscription()
                    case .appicon:
                        SettingsAppIcon()
                    }
                }
        }
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
