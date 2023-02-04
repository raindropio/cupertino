import SwiftUI
import API
import UI

//MARK: - Available pages
enum AppRoute: Hashable {
    case find(FindBy)
    case multi(Int = 0)
}

//MARK: - Service
class AppRouter: ObservableObject {
    @Published var path: [AppRoute] = [
        .find(.init())
    ]
    @Published var spotlight = false
    @Published var preview: URL?
    
    func push(_ screen: AppRoute) {
        if path.last != screen {
            path.append(screen)
        }
    }
    
    func replace(_ screen: AppRoute) {
        if !path.isEmpty {
            path.removeLast()
        }
        push(screen)
    }
}

//MARK: Shorthands
extension AppRouter {
    func find(_ find: FindBy) {
        push(.find(find))
    }
    
    func find(_ filter: Filter) {
        push(.find(.init(filter)))
    }
    
    func find(_ collection: UserCollection) {
        push(.find(.init(collection)))
    }
}
