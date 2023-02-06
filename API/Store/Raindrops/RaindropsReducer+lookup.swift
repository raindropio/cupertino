import SwiftUI

extension RaindropsReducer {
    func lookup(state: inout S, url: URL) async {
        let item = try? await rest.raindropGet(link: url)
        if let item {
            state.items[item.id] = item
        }
    }
}
