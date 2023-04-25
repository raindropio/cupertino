import Foundation

public struct RecentState: ReduxState {
    @Persisted("res-search") var search = [String]()
    @Persisted("res-tags") public var tags = [String]()
    public var animation = UUID()

    public init() { }
}

extension RecentState {
    public func search(_ find: FindBy = .init()) -> [String] {
        guard find.collectionId == 0 && !find.isSearching
        else { return [] }
        
        return search
    }
}
