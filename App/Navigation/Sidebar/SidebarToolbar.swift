import SwiftUI

struct SidebarToolbar: ViewModifier {
    @State private var showSettings = false

    func body(content: Content) -> some View {
        content
            .navigationTitle("exentrich")
            .toolbar {
                #if os(iOS)
                if UIDevice.current.userInterfaceIdiom == .pad {
                    ToolbarItem {
                        Button(action: { showSettings = true }) {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                }
                #endif
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            #endif
    }
}
