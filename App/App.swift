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
            } notAuthorized: {
                AuthScene()
            }
                .storeProvider(store)
        }
    }
}
