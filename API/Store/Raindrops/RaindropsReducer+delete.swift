extension RaindropsReducer {
    func deleteMany(state: S, pick: RaindropsPick) async throws -> ReduxAction? {
        let _ = try await rest.raindropsDelete(pick: pick)
        //ignore count response, sometime user remove already removed items
        return A.deletedMany(pick)
    }
    
    func deletedMany(state: inout S, pick: RaindropsPick) {
        let touched = state.pickItems(pick: pick)
        var modified = [Raindrop]()
        
        for item in touched {
            //permanent remove
            if item.collection == -99 {
                state.items.removeValue(forKey: item.id)
                for (find, _) in state.segments {
                    state.segments[find]?.ids.removeAll { $0 == item.id }
                }
            }
            //move to trash
            else {
                state.items[item.id]?.collection = -99
                if let item = state.items[item.id] {
                    modified.append(item)
                }
            }
        }
        
        if !modified.isEmpty {
            state.updateSegments(modified)
        }
        
        state.animation = .init()
    }
}

extension RaindropsReducer {
    func deletedCollections(state: inout S, ids: Set<UserCollection.ID>) {
        state.segments = state.segments.filter {
            !ids.contains($0.key.collectionId)
        }
    }
}
