import SwiftUI
import API
import UI
import Features

struct AppScene: View {
    @StateObject private var router = AppRouter()
    @AppStorage("theme") private var theme: PreferredTheme = .default

    var body: some View {
        NavigationSplitView(sidebar: SidebarScreen.init) {
            NavigationStack {
                if let find = router.find {
                    Finder(find: find)
                        .navigationDestination(for: UserCollection.self) {
                            Finder(find: .init($0))
                        }
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
            .overlayWindow(isPresented: $router.spotlight) {
                Spotlight()
                    .spotlightEvents {
                        switch $0 {
                        case .collection(let collection):
                            router.find = .init(collection)
                            router.spotlight = false
                            
                        case .raindrop(let raindrop):
                            router.preview = raindrop.link
                            
                        case .find(let find):
                            router.find = find
                            router.spotlight = false
                            
                        case .cancel:
                            router.spotlight = false
                            break
                        }
                    }
            }
            .fullScreenCover(item: $router.preview) { url in
                NavigationStack {
                    PreviewScreen(url: url, mode: .raw)
                }
            }
            .environmentObject(router)
            .preferredColorScheme(theme.colorScheme)
    }
}
