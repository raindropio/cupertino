import SwiftUI

extension RaindropsReducer {
    func lookup(state: S, url: URL) async -> ReduxAction? {
        let id = state.lookups[url.compact]
        guard let id else { return nil }
        
        let item = try? await rest.raindropGet(id: id)
        if let item {
            return A.loaded(item)
        }
        return nil
    }
}
