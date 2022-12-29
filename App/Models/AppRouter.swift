import SwiftUI
import API
import UI

//MARK: - Available pages
enum AppRoute: Hashable {
    case browse(FindBy)
    case multi(Int = 0)
    case preview(URL, PreviewScreen.Mode = .raw)
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
    
    func preview(_ url: URL, _ mode: PreviewScreen.Mode = .raw) {
        push(.preview(url, mode))
    }
}

//MARK: - Helpers
extension AppRouter {
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
