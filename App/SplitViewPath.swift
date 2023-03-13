import SwiftUI
import API
import UI
import Features

struct SplitViewPath: Codable {
    var sidebar: FindBy? = .init()
    var detail: [Screen] = []
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
        if sidebar == nil { sidebar = .init() }
        if detail.last != screen {
            detail += [screen]
        }
    }
}
