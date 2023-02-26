import SwiftUI
import API
import Features

@main
struct RaindropApp: App {
    @StateObject private var store = Store()

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
                .environmentObject(store.collaborators)
                .environmentObject(store.collections)
                .environmentObject(store.config)
                .environmentObject(store.filters)
                .environmentObject(store.icons)
                .environmentObject(store.raindrops)
                .environmentObject(store.filters)
                .environmentObject(store.recent)
                .environmentObject(store.subscription)
                .environmentObject(store.user)
        }
    }
}
