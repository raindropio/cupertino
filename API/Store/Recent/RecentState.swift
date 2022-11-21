import Foundation

public struct RecentState: ReduxState {
    @Cached("res-search") var search = [String]()
    @Cached("res-tags") public var tags = [String]()
    
    public init() { }
}

extension RecentState {
    public func search(_ find: FindBy = .init()) -> [String] {
        guard find.collectionId == 0 && !find.isSearching
        else { return [] }
        
        return search
    }
}
