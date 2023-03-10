import SwiftUI
import API
import UI

class AppRouter: ObservableObject {
    @Published var sidebar: FindBy? = .init()
    @Published var path: [Path] = []
}

extension AppRouter {
    enum Path: Hashable, Codable {
        case find(FindBy)
        case preview(FindBy, Raindrop.ID)
        case cached(Raindrop.ID)
        case browse(URL)
    }
}

extension AppRouter {
    func find(_ find: FindBy) {
        if sidebar == nil || !isPhone {
            sidebar = find
            return
        }
        
        if path.last != .find(find) {
            path.append(.find(find))
        }
    }
    
    func find(collection: UserCollection.ID) {
        find(.init(collection))
    }
    
    func preview(find: FindBy, id: Raindrop.ID) {
        if sidebar == nil { sidebar = .init() }
        path += [.preview(find, id)]
    }
    
    func cached(id: Raindrop.ID) {
        if sidebar == nil { sidebar = .init() }
        path += [.cached(id)]
    }
    
    func browse(url: URL) {
        if sidebar == nil { sidebar = .init() }
        path += [.browse(url)]
    }
}
