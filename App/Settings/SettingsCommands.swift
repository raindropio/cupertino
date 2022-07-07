import SwiftUI

#if os(macOS)
struct SettingsCommands: Commands {
    @Environment(\.openWindow) private var openWindow
    
    var body: some Commands {
        CommandGroup(after: .appInfo) {
            Divider()
            
            Button(action: {
                openWindow(id: "settings")
            }) {
                Label("Settings", systemImage: "gear")
            }
                .keyboardShortcut(",", modifiers: [.command])
        }
    }
}
#endif
