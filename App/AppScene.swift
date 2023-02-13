import SwiftUI
import API
import UI
import Features

struct AppScene: View {
    @StateObject private var router = AppRouter()
    @AppStorage("theme") private var theme: PreferredTheme = .default

    var body: some View {
        NavigationSplitView(sidebar: SidebarScreen.init) {
            NavigationStack(path: $router.path) {
                Group {
                    if let space = router.space {
                        Space(find: space)
                    }
                }
                    //screens
                    .navigationDestination(for: FindBy.self, destination: Space.init)
                    .navigationDestination(for: Browse.Location.self, destination: Browse.init)
            }
                .navigationBarTitleDisplayMode(.large) //fix iphone bug
        }
            .navigationSplitViewUnlimitedWidth()
            .containerSizeClass()
            .collectionSheets()
            .tagSheets()
            .dropProvider()
            .environmentObject(router)
            .preferredColorScheme(theme.colorScheme)
            //item links
            .itemDestination("preview", for: Raindrop.self) { router.navigate(raindrop: $0) }
            .itemDestination("cache", for: Raindrop.self) { router.navigate(raindrop: $0, mode: .cache) }
            .itemDestination(for: Raindrop.self) { router.navigate(raindrop: $0) }
            .itemDestination(for: UserCollection.self) { router.navigate(collection: $0) }
    }
}
