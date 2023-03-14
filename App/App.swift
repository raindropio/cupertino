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
                #if canImport(AppKit)
                .frame(minWidth: 600, minHeight: 400)
                #endif
        }
            #if canImport(AppKit)
            .windowResizability(.contentSize)
            .defaultPosition(.center)
            .defaultSize(width: 800, height: 600)
            #endif
        
        #if canImport(AppKit)
        Settings {
            SettingsLogout()
                .storeProvider(store)
        }
        #endif
    }
}
