import SwiftUI

struct Main: View {
    var body: some View {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            PhoneView()
        } else {
            HomeView()
        }
        #else
        HomeView()
        #endif
    }
}

struct PhoneView: View {
    @State private var detailPath = NavigationPath()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "folder")
                }
            
            DetailView(section: .collection(.Preview.system.first!), path: $detailPath)
                .tabItem {
                    Image(systemName: "star")
                }
            
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                }
        }
    }
}
