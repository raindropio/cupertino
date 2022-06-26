import SwiftUI

struct SettingsView: View {
    @State var page: SettingsPage?
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List(selection: $page) {
                Label("Import", systemImage: "square.and.arrow.down")
                    .tag(SettingsPage.import)
            }
                .navigationTitle("Settings")
        } detail: {
            ZStack {
                switch(page) {
                    case .import: ImportView()
                    default: EmptyView()
                }
            }
        }
    }
}
