extension RaindropsReducer {
    func update(state: inout S, modified: Raindrop) async throws -> ReduxAction? {
        //ignore if no original or nothing modified
        guard let original = state.items[modified.id], modified != original
        else { return nil }
        
        return A.updated(
            try await rest.raindropUpdate(
                original: original,
                modified: modified
            )
        )
    }
    
    //MARK: - Receive updated raindrop from server
    func updated(state: inout S, raindrop: Raindrop) {
        state.items[raindrop.id] = raindrop
        state.updateSegments(raindrop)
    }
}

extension RaindropsReducer {
    func updateMany(state: inout S, pick: RaindropsPick, operation: UpdateRaindropsRequest) async throws -> ReduxAction? {
        let count = try await rest.raindropsUpdate(pick: pick, operation: operation)
        if count > 0 {
            return A.updatedMany(pick, operation)
        }
        return nil
    }
    
    func updatedMany(state: inout S, pick: RaindropsPick, operation: UpdateRaindropsRequest) {
        state.updateSegments(
            state.pickItems(pick: pick).map { $0.id }.compactMap { id in
                switch operation {
                case .important(let important):
                    state.items[id]?.important = important
                    
                case .moveTo(let collection):
                    state.items[id]?.collection = collection
                    
                case .addTags(let tags):
                    tags.forEach {
                        if !(state.items[id]?.tags.contains($0) ?? false) {
                            state.items[id]?.tags.append($0)
                        }
                    }
                    
                case .removeTags:
                    state.items[id]?.tags = []
                }
                
                return state.items[id]
            }
        )
    }
}
