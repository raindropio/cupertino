import SwiftUI
import API
import Common

@main
struct RaindropApp: App {
    @StateObject private var store = Store(keychain: "7459JWM5TY.secrets")

    var body: some Scene {
        WindowGroup {
            AuthGroup {
                AppScene()
                    #if os(iOS)
                    .modifier(SettingsScene.Attach())
                    #endif
            } notAuthorized: {
                AuthScene()
            }
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
