extension RaindropsReducer {
    func loadMore(state: inout S, find: FindBy) async throws {
        //ignore when already loading
        guard state[find].status == .idle, state[find].more != .loading
        else { return }
                
        //loading state
        state[find].more = .loading
        
        do {
            let sort = state.sort(find)
            let nextPage = state[find].page + 1
            let (items, total) = try await rest.raindropsGet(find, sort: sort, page: nextPage)
            
            //correct page validation
            guard nextPage == state[find].page + 1
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
            state[find].more = state[find].ids.count >= total ? .notFound : .idle
            state[find].page = nextPage
            state[find].total = total
        }
        catch RestError.notFound {
            state[find].more = .notFound
        }
        catch {
            state[find].more = .error
            throw error
        }
    }
}
