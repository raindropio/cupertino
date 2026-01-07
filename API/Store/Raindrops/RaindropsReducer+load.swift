extension RaindropsReducer {
    //MARK: - 1
    func load(state: inout S, find: FindBy) -> ReduxAction? {
        //default sort
        if !state.exists(find) {
            state[find].sort = SortBy.someCases(for: find).first!
        }
        
        state[find].status = .loading
                
        return A.reload(find)
    }
    
    //MARK: - 2
    func reload(state: S, find: FindBy) async -> ReduxAction? {
        do {
            let sort = state.sort(find)
            let (items, total) = try await rest.raindropsGet(find, sort: sort)
            return A.reloaded(find, items, total)
        }
        catch {
            return A.reloadFailed(find, error)
        }
    }
    
    //MARK: - 3
    func reloadFailed(state: inout S, find: FindBy, error: Error) throws {
        switch error {
        case RestError.notFound, RestError.forbidden, RestError.unauthorized:
            state[find] = .init()
            state[find].status = .notFound
        
        case is CancellationError:
            state[find].status = .idle
            state[find].validMore()
        
        default:
            state[find].status = .error
            throw error
        }
    }
    
    //MARK: - 4
    func reloaded(state: inout S, find: FindBy, items: [Raindrop], total: Int) {
        //add to items dictionary and update group
        state.items.merge(items.map { ($0.id, $0) }) { _, new in new }
        
        //do not override if data is not modified (useful for pagination)
        let oldIds = state[find].ids
        let newIds = items.map(\.id)
        
        //animate addition/deletion
        if total > state[find].total || total < state[find].total {
            state.animation = .init()
        }

        if state[find].total != total || oldIds.count < newIds.count || oldIds[0..<newIds.count] != newIds[0..<newIds.count] {
            state[find].ids = newIds
            state[find].page = 0
        }
        
        state[find].status = .idle
        state[find].total = total
        state[find].validMore()
    }
    
    func loaded(state: inout S, raindrop: Raindrop) {
        state.items[raindrop.id] = raindrop
    }
}
