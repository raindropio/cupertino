import SwiftUI
import API
import UI

class AppRouter: ObservableObject {
    @Published private var path: [Path] = [.find(.init())]
    @Published var searchPreferred = false
    
    var sidebar: FindBy? {
        get {
            switch path.first {
            case .find(let find): return find
            default: return nil
            }
        }
        set {
            guard sidebar != newValue else { return }
            if let newValue {
                path = [.find(newValue)]
            } else {
                path = []
            }
        }
    }
    
    var detail: [Path] {
        get {
            path.isEmpty ? [] : Array(path[1...])
        } set {
            guard detail != newValue else { return }
            path = (!path.isEmpty ? [path[0]] : []) + newValue
        }
    }
}

extension AppRouter {
    enum Path: Hashable {
        case find(FindBy)
        case preview(FindBy, Raindrop.ID)
        case cached(Raindrop.ID)
        case browse(URL)
    }
}

extension AppRouter {
    func search() {
        if path.isEmpty {
            path.append(.find(.init()))
        }
        searchPreferred = true
    }
    
    func find(_ find: FindBy) {
        if path.isEmpty {
            path.append(.find(.init()))
        } else {
            path.append(.find(find))
        }
    }
    
    func find(collection: UserCollection.ID) {
        find(.init(collection))
    }
    
    func preview(find: FindBy, id: Raindrop.ID) {
        path.append(.preview(find, id))
    }
    
    func cached(id: Raindrop.ID) {
        path.append(.cached(id))
    }
    
    func browse(url: URL) {
        path.append(.browse(url))
    }
}
