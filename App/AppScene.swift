import SwiftUI
import API
import UI
import Features

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
                
            case .preview(let url, let mode):
                PreviewScreen(url: url, mode: mode)
            }
        }
            .navigationSplitViewConfiguration(sidebarMin: 400)
            .collectionsEvent()
            .tagsEvent()
            .dropProvider()
            .fancySheet(isPresented: $router.spotlight) {
                Spotlight()
                    .spotlightEvents {
                        switch $0 {
                        case .collection(let collection):
                            router.find(collection)
                            
                        case .raindrop(let raindrop):
                            router.preview(raindrop.link)
                            
                        case .find(let find):
                            router.find(find)
                            
                        case .cancel:
                            break
                        }
                        router.spotlight = false
                    }
            }
            .environmentObject(router)
            .preferredColorScheme(theme.colorScheme)
    }
}
