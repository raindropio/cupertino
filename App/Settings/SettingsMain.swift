import SwiftUI

struct SettingsMain: View {
    @State var page: SettingsPage?
    
    #if os(iOS)
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                NavigationLink(value: SettingsPage.import) {
                    Label(SettingsPage.import.title, systemImage: SettingsPage.import.systemImage)
                }
            }
                .navigationTitle("Settings")
                .navigationDestination(for: SettingsPage.self) { page in
                    switch(page) {
                        case .account: AccountView()
                        case .import: ImportView()
                    }
                }
        }
        .onAppear {
            if let page = page {
                path.append(page)
            }
        }
        .onChange(of: page) {
            if let selected = $0 {
                path.append(selected)
            } else {
                path.removeLast(path.count)
            }
        }
    }
    #else
    var body: some View {
        TabView(selection: $page) {
            ImportView()
                .tabItem {
                    Label(SettingsPage.import.title, systemImage: SettingsPage.import.systemImage)
                }
                .tag(SettingsPage.import)
            
            AccountView()
                .tabItem {
                    Label(SettingsPage.account.title, systemImage: SettingsPage.account.systemImage)
                }
                .tag(SettingsPage.account)
        }
        .frame(minWidth: 500, minHeight: 100)
    }
    #endif
}
