import SwiftUI

@main
struct RaindropApp: App {
    var body: some Scene {
        WindowGroup {
            Main()
        }
            #if os(macOS)
            .commands {
                SidebarCommands()
            }
            #endif
        
        #if os(macOS)
        Settings {
            SettingsMain()
        }
        #endif
    }
}
