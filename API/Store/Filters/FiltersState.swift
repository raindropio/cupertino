import Foundation

public struct FiltersState: ReduxState {
    @Cached("ffs-simple") var simple = [FindBy: [Filter]]()
    @Cached("ffs-tags") var tags = [FindBy: [Filter]]()
    @Cached("ffs-created") var created = [FindBy: [Filter]]()
    
    @Cached("ffs-sort") public var sort = TagsSort.title
    public var animation = UUID()
    
    public init() {}
}

extension FiltersState {
    public func simple(_ find: FindBy = .init()) -> [Filter] {
        return withoutCompletion(find, simple[find])
    }
    
    public func tags(_ find: FindBy = .init()) -> [Filter] {
        return withoutCompletion(find, tags[find])
    }
    
    public func created(_ find: FindBy = .init()) -> [Filter] {
        return withoutCompletion(find, created[find])
    }
}
