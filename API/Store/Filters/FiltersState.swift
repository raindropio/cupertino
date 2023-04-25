import Foundation

public struct FiltersState: ReduxState {
    @Persisted("ffs-simple") var simple = [FindBy: [Filter]]()
    @Persisted("ffs-tags") var tags = [FindBy: [Filter]]()
    @Persisted("ffs-created") var created = [FindBy: [Filter]]()
    
    @Persisted("ffs-sort") public var sort = TagsSort.title
    public var animation = UUID()
    
    public init() {}
}

extension FiltersState {
    public func simple(_ find: FindBy = .init()) -> [Filter] {
        simple[find] ?? []
    }
    
    public func tags(_ find: FindBy = .init()) -> [Filter] {
        tags[find] ?? []
    }
    
    public func tags(_ search: String) -> [Filter] {
        let tags = tags[.init()] ?? []
        
        if search.isEmpty {
            return tags
        }
        
        return tags.filter {
            $0.contains(search)
        }
    }
    
    public func created(_ find: FindBy = .init()) -> [Filter] {
        created[find] ?? []
    }
}
