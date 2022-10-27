import Foundation

public struct RecentState: Equatable {
    @Cached("res-search") var search = [String]()
    @Cached("res-tags") var tags = [String]()
}

extension RecentState {
    public func search(_ find: FindBy?) -> [String] {
        guard find == nil || (find!.collectionId == 0 && !find!.isSearching)
        else { return [] }
        
        return search
    }
}
