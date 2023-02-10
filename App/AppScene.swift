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
                if let space = router.space {
                    Space(find: space)
                        //screens
                        .navigationDestination(for: UserCollection.ID.self) {
                            Space(find: .init($0))
                        }
                        .navigationDestination(for: FindBy.self, destination: Space.init)
                        .navigationDestination(for: Browse.Location.self, destination: Browse.init)
                        //item links
                        .itemDestination("preview", for: Raindrop.self) { router.browse($0) }
                        .itemDestination("cache", for: Raindrop.self) { router.browse($0, mode: .cache) }
                        .itemDestination(for: Raindrop.self) { router.browse($0) }
                        .itemDestination(for: UserCollection.self) { router.path.append($0) }
                }
            }
                .navigationBarTitleDisplayMode(.large) //fix iphone bug
        }
            .navigationSplitViewStyle(.balanced)
            .navigationSplitViewUnlimitedWidth()
            .containerSizeClass()
            .collectionsEvent()
            .tagsEvent()
            .dropProvider()
            .environmentObject(router)
            .preferredColorScheme(theme.colorScheme)
    }
}
