extension RaindropsReducer {
    func more(state: inout S, find: FindBy) -> ReduxAction? {
        //ignore when already loading
        guard state[find].status == .idle && state[find].more != .loading
        else { return nil }
        
        state[find].more = .loading
        
        return A.moreLoad(find)
    }
    
    func moreLoad(state: inout S, find: FindBy) async -> ReduxAction? {
        let page = state[find].page + 1
        
        do {
            let sort = state.sort(find)
            let (items, total) = try await rest.raindropsGet(find, sort: sort, page: page)
            
            return A.moreLoaded(find, page, items, total)
        }
        catch {
            return A.moreFailed(find, page, error)
        }
    }
    
    func moreFailed(state: inout S, find: FindBy, page: Int, error: Error) throws {
        //correct page validation
        guard page == state[find].page + 1
        else { return }
        
        switch error {
        case RestError.notFound, RestError.forbidden, RestError.unauthorized:
            state[find].more = .notFound
            
        case is CancellationError:
            state[find].more = .idle
            state[find].validMore()
            
        default:
            state[find].more = .error
            throw error
        }
    }
    
    func moreLoaded(state: inout S, find: FindBy, page: Int, items: [Raindrop], total: Int) {
        //correct page validation
        guard page == state[find].page + 1
        else { return }
        
        //no more pages
        if items.isEmpty {
            state[find].more = .notFound
            return
        }
        
        //data corruption check
        let existingIds = state[find].ids
        guard !(items.contains { existingIds.contains($0.id) })
        else {
            state[find].more = .error
            return
        }
        
        //add to items dictionary and update group
        items.forEach { state.items[$0.id] = $0 }
        
        state[find].ids = state[find].ids + items.map(\.id)
        state[find].page = page
        state[find].total = total
        state[find].validMore()
    }
}
