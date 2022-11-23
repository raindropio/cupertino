import SwiftUI
import API
import UI

extension BrowseBulk {
    static func title(_ pick: RaindropsPick) -> String {
        switch pick {
        case .all(_): return "All Items"
        case .some(let selection): return "\(selection.count) Items"
        }
    }
}
