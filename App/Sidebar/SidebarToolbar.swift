import SwiftUI

struct SidebarToolbar: ViewModifier {
    @EnvironmentObject private var settings: SettingsService
    
    func body(content: Content) -> some View {
        content
            .navigationTitle("Exentrich")
            .toolbar {
                #if os(iOS)
                if UIDevice.current.userInterfaceIdiom == .pad {
                    ToolbarItem {
                        Button(action: { settings.page = .index }) {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                }
                #endif
            }
    }
}
