import SwiftUI
import API

@main
struct RaindropApp: App {
    @StateObject private var store = Store()

    var body: some Scene {
        WindowGroup {
            AuthGroup(
                authorized: AppScene.init,
                notAuthorized: AuthScene.init
            )
                .modifier(SettingsScene.Attach())
                .environmentObject(store.dispatcher)
                .environmentObject(store.auth)
                .environmentObject(store.collections)
                .environmentObject(store.filters)
                .environmentObject(store.icons)
                .environmentObject(store.raindrops)
                .environmentObject(store.filters)
                .environmentObject(store.recent)
                .environmentObject(store.user)
        }
    }
}
