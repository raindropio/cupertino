import SwiftUI
import API
import UI

public struct SearchSuggestions: View {
    @Environment(\.defaultMinListHeaderHeight) private var h
    
    var find: FindBy
    
    public init(_ find: FindBy) {
        self.find = find
    }
    
    public var body: some View {
        SuggestedFilters(find: find)
        RecentSearches(find: find)
        //TODO: recent collections/bookmarks
        SuggestedCompletion(find: find)
        FoundCollections(find: find)
    }
}
