extension FiltersReducer {
    func reload(state: inout S, find: FindBy) async throws -> ReduxAction? {
        var config: FiltersConfig?
        
        //reload config only for root
        if find == .init() {
            config = try await rest.configGet()
        }
        
        let (filters, _) = try await rest.filtersGet(find, tagsSort: config?.tagsSort ?? .title)
        return A.reloaded(find, filters, config)
    }
    
    func reloaded(state: inout S, find: FindBy, filters: [Filter], config: FiltersConfig? = nil) {
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
        
        if state.tags[find] != tags {
            state.animation = .init()
        }
                
        state.simple[find] = simple
        state.tags[find] = tags
        state.created[find] = created
        
        if let config {
            state.config = config
        }
    }
}
