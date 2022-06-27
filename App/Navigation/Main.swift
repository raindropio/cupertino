import SwiftUI

struct Main: View {
    var body: some View {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            PhoneView()
        } else {
            Home()
        }
        #else
        Home()
        #endif
    }
}

struct PhoneView: View {
    @State private var detailPath = NavigationPath()
    
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "folder")
                }
            
            Detail(section: .collection(.Preview.system.first!), path: $detailPath)
                .tabItem {
                    Image(systemName: "star")
                }
            
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            
            SettingsMain()
                .tabItem {
                    Image(systemName: "gear")
                }
        }
    }
}
