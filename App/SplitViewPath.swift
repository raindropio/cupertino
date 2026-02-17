import SwiftUI
import API
import UI
import Features

struct SplitViewPath: Codable, Equatable {
    var sidebar: FindBy? = .init()
    var detail: [Screen] = []
    var ask = false
}

extension SplitViewPath {
    enum Screen: Hashable, Codable {
        case find(FindBy)
        case preview(FindBy, Raindrop.ID)
        case cached(Raindrop.ID)
        case browse(URL)
    }
}

extension SplitViewPath {
    var lastFind: FindBy? {
        for screen in detail.reversed() {
            switch screen {
            case .find(let find), .preview(let find, _):
                return find
            default:
                continue
            }
        }
        return sidebar
    }
    
    var preferredCompactColumn: NavigationSplitViewColumn {
        if sidebar != nil || !detail.isEmpty { return .detail }
        return .sidebar
    }
}

extension SplitViewPath {
    mutating func push(_ find: FindBy) {
        if sidebar == nil || !isPhone {
            sidebar = find
            return
        }
        
        if detail.last != .find(find) {
            detail.append(.find(find))
        }
    }
    
    mutating func push(_ screen: Screen) {
        if detail.last != screen {
            detail += [screen]
        }
    }
}
