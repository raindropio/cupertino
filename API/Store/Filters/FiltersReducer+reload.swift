extension FiltersReducer {
    func reload(state: inout S, find: FindBy) async throws {
        let (filters, _) = try await rest.filtersGet(find)
        
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
                
        state.simple[find] = simple
        state.tags[find] = tags
        state.created[find] = created
    }
}
