import SwiftUI

@main
struct RaindropApp: App {
    var body: some Scene {
        WindowGroup {
            Main()
        }
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
