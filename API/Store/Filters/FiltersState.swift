import Foundation

public struct FiltersState: ReduxState {
    @Cached("ffs-simple") var simple = [FindBy: [Filter]]()
    //@Cached("ffs-tags") 
    var tags = [FindBy: [Filter]]()
    @Cached("ffs-created") var created = [FindBy: [Filter]]()
    
    @Cached("ffs-sort") public var sort = TagsSort.title
    public var animation = UUID()
    
    public init() {}
}

extension FiltersState {
    public func simple(_ find: FindBy = .init()) -> [Filter] {
        simple[find] ?? []
    }
    
    public func tags(_ find: FindBy = .init()) -> [Filter] {
        //search by text
        if !find.text.trimmingCharacters(in: .whitespaces).isEmpty {
            return tags[find.excludingText()]?.filter {
                $0.completionEnd(of: find.text) > 0
            } ?? []
        }
        
        return tags[find] ?? []
    }
    
    public func created(_ find: FindBy = .init()) -> [Filter] {
        created[find] ?? []
    }
}
