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
        case .tag(let tag):
            EmptyView()
        case .filter(let filter):
            Browse(collection: Collection.Preview.system.first!, search: .init(tokens: [.filter(filter)]))
        case .preview(let raindrop):
            Preview(raindrop: raindrop)
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
