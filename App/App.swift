import SwiftUI

@main
struct RaindropApp: App {
    var body: some Scene {
        WindowGroup {
            Main()
        }
            #if os(macOS)
            .commands {
                SettingsCommands()
                SidebarCommands()
            }
            #endif
        
        #if os(macOS)
        Window("Settings", id: "settings") {
            SettingsMain()
                .frame(width: 600, height: 400)
        }
            .windowResizability(.contentSize)
            .defaultPosition(.center)
        #endif
    }
}
