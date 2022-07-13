import SwiftUI
import API

#if os(iOS)
struct PhoneScene: View {
    @State private var tab: PhoneTab = .collections

    @StateObject private var router = Router()
    @StateObject private var all = Router()
    @StateObject private var search = Router()
    @StateObject private var settings = SettingsService()
    
    var body: some View {
        TabView(selection: $tab) {
            SplitViewScene()
                .environmentObject(router)
                .tabItem {
                    Image(systemName: "folder")
                }
                .tag(PhoneTab.collections)
            
            RouterView(index: .browse(Collection.Preview.system.first!, nil))
                .environmentObject(all)
                .tabItem {
                    Image(systemName: "star")
                }
                .tag(PhoneTab.all)
            
            RouterView(index: .search)
                .environmentObject(search)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(PhoneTab.search)
            
            SettingsIOS()
                .environmentObject(settings)
                .tabItem {
                    Image(systemName: "gear")
                }
                .tag(PhoneTab.settings)
        }
            .onOpenURL {
                router.handleDeepLink($0)
                settings.handleDeepLink($0)
            }
            .onAppear {
                if settings.page != nil { tab = .settings }
            }
            .onChange(of: settings.page) { if $0 != nil { tab = .settings } }
    }
}

enum PhoneTab: Hashable {
    case collections
    case all
    case search
    case settings
}
#endif
