import SwiftUI

extension RaindropsReducer {
    func lookup(state: S, url: URL) async -> ReduxAction? {
        var id = state.item(url)?.id
        if id == nil {
            id = try? await rest.raindropGetId(url: url)
        }
        guard let id else { return nil }
        
        do {
            let item = try await rest.raindropGet(id: id)
            if let item {
                return A.loaded(item)
            } else {
                return A.deletedMany(.some([id]))
            }
        } catch {
            return nil
        }
    }
}
