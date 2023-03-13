import SwiftUI
import API
import Features

@main struct RaindropApp: App {
    @StateObject private var store = Store()

    var body: some Scene {
        WindowGroup {
            AuthGroup(
                authorized: SplitView.init,
                notAuthorized: AuthScreen.init
            )
                .storeProvider(store)
        }
    }
}
