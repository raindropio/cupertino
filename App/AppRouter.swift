import SwiftUI
import API
import UI

class AppRouter: ObservableObject {
    @Published var space: FindBy? = .init()
    @Published var path: NavigationPath = .init()
    @Published var searchPreferred = false
}

extension AppRouter {
    func search() {
        if space == nil {
            space = .init()
        }
        searchPreferred = true
    }
    
    func navigate(find: FindBy) {
        if space == nil {
            space = find
        } else {
            path.append(find)
        }
    }
    
    func navigate(collection: UserCollection.ID) {
        navigate(find: FindBy(collection))
    }
    
    func navigate(raindrop: Raindrop.ID, mode: Browse.Location.Mode? = nil) {
        path.append(Browse.Location(kind: .raindrop(raindrop), mode: mode))
    }
}
