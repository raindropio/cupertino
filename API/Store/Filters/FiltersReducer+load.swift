extension FiltersReducer {
    func reload(state: inout S, find: FindBy) async throws -> ReduxAction? {
        let (filters, _) = try await rest.filtersGet(find, tagsSort: state.sort)
        return A.reloaded(find, filters)
    }
    
    func reloaded(state: inout S, find: FindBy, filters: [Filter]) {
        var simple = [Filter]()
        var tags = [Filter]()
        var created = [Filter]()
        
        filters.forEach {
            switch $0.kind {
            case .tag(_), .notag: tags.append($0)
            case .created(_): created.append($0)
            case .type(let type): if type != .link { simple.append($0) } //ignore .link types
            default: simple.append($0)
            }
        }
        
        if state.tags[find]?.count != tags.count {
            state.animation = .init()
        }
                
        state.simple[find] = simple
        state.tags[find] = tags
        state.created[find] = created
    }
}
