import SwiftUI
import API

struct SidebarView: View {
    @Binding var page: BrowserPage?
    @State private var showSettings = false

    var body: some View {
        List(selection: $page) {
            CollectionsTreeView {
                BrowserPage.collection($0)
            }
        }
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
