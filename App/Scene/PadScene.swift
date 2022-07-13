import SwiftUI

#if os(iOS)
struct PadScene: View {
    @StateObject private var router = Router()
    @StateObject private var settings = SettingsService()

    var body: some View {
        SplitViewScene()
            .sheet(item: $settings.page) { _ in
                SettingsIOS()
            }
            .environmentObject(router)
            .environmentObject(settings)
            .onOpenURL {
                router.handleDeepLink($0)
                settings.handleDeepLink($0)
            }
    }
}
#endif
