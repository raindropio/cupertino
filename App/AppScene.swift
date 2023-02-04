import SwiftUI
import API
import UI
import Features
import Backport

struct AppScene: View {
    @StateObject private var router = AppRouter()
    @AppStorage("theme") private var theme: PreferredTheme = .default

    var body: some View {
        SplitView(path: $router.path) {
            SidebarScreen()
        } detail: { screen in
            switch screen {
            case .find(let find):
                Finder(find: find)
                
            case .multi(let count):
                EmptyState("\(count) items") {
                    Image(systemName: "checklist.checked")
                } actions: {
                    Button("Cancel") { router.path = [.find(.init(0))] }
                }
            }
        }
            .navigationSplitViewConfiguration(sidebarMin: 400)
            .collectionsEvent()
            .tagsEvent()
            .dropProvider()
            .overlayWindow(isPresented: $router.spotlight) {
                Spotlight()
                    .spotlightEvents {
                        switch $0 {
                        case .collection(let collection):
                            router.find(collection)
                            router.spotlight = false
                            
                        case .raindrop(let raindrop):
                            router.preview = raindrop.link
                            
                        case .find(let find):
                            router.find(find)
                            router.spotlight = false
                            
                        case .cancel:
                            router.spotlight = false
                            break
                        }
                    }
            }
            .fullScreenCover(item: $router.preview) { url in
                Backport.NavigationStack {
                    PreviewScreen(url: url, mode: .raw)
                }
            }
            .environmentObject(router)
            .preferredColorScheme(theme.colorScheme)
    }
}
