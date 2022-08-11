import SwiftUI
import API

struct RouterView: View {
    @EnvironmentObject private var router: Router
    var index: Route?
    
    @ViewBuilder
    func screenForRoute(_ route: Route) -> some View {
        switch route {
        case .browse(let collection, let search):
            Browse(collection: collection, search: search ?? .init())
                .id(search)
        case .tag(let tag):
            Browse(search: .init(tokens: [.tag(tag)]))
                .id(tag)
        case .filter(let filter):
            Browse(search: .init(tokens: [.filter(filter)]))
                .id(filter)
        case .preview(let id):
            Preview(raindrop: id)
        case .search: Search()
        }
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if let route = index {
                    screenForRoute(route)
                } else {
                    Text("Empty")
                }
            }
                .navigationDestination(for: Route.self) {
                    screenForRoute($0)
                }
        }
    }
}
