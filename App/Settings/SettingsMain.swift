import SwiftUI

struct SettingsMain: View {
    @State var page: SettingsPage?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List(selection: $page) {
                Section {
                    SettingsRow(page: .account)
                    SettingsRow(page: .pro)
                }
                
                Section {
                    SettingsRow(page: .import)
                }
            }
                .navigationSplitViewColumnWidth(180)
                .navigationTitle("Settings")
        } detail: {
            ZStack {
                if let page = page {
                    switch(page) {
                    case .account: AccountView()
                    case .pro: ProView()
                    case .import: ImportView()
                    }
                }
            }
        }
            .navigationSplitViewStyle(.balanced)
            .onAppear {
                if page == nil, horizontalSizeClass == .regular {
                    page = .account
                }
            }
    }
}
