import SwiftUI
import API
import UI

//MARK: - Available pages
enum AppRoute: NavigationPane {
    case browse(FindBy)
    case open(Raindrop)
    
    var appearance: NavigationPaneAppearance {
        switch self {
        case .open(_): return .fullScreen
        default: return .automatic
        }
    }
}

//MARK: - Service
class AppRouter: ObservableObject {
    @Published var path: [AppRoute] = [
        .browse(.init())
    ]
    
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
    func browse(_ filter: Filter) {
        push(.browse(.init(filter)))
    }
    
    func browse(_ collection: UserCollection) {
        push(.browse(.init(collection)))
    }
    
    func open(_ raindrop: Raindrop) {
        push(.open(raindrop))
    }
}

//MARK: - Helpers
extension AppRouter {
    var sidebarSelection: Int? {
        get {
            if let screen = path.first, case .browse(let find) = screen {
                return find.collectionId
            }
            return nil
        } set {
            if let collectionId = newValue {
                path = [.browse(.init(collectionId))]
            } else {
                path = []
            }
        }
    }
    
    func bind(_ find: FindBy) -> Binding<FindBy> {
        .init {
            find
        } set: { [weak self] next in
            let index = self?.path.firstIndex(of: .browse(find))
            if let index {
                self?.path[index] = .browse(next)
            }
        }
    }
}
