import SwiftUI
import API

public struct FindCollections: View {
    @EnvironmentObject private var collections: CollectionsStore
    var search: String
    
    public init(search: String) {
        self.search = search
    }
    
    public init(find: FindBy) {
        if find.collectionId == 0 {
            self.search = find.text
        } else {
            self.search = ""
        }
    }
    
    public var body: some View {
        Memorized(
            user: collections.state.find(search)
        )
    }
}

extension FindCollections {
    fileprivate struct Memorized: View {
        var user: [UserCollection]
        
        var body: some View {
            if !user.isEmpty {
                Section("\(user.count) collections") {
                    ForEach(user) { item in
                        UserCollectionRow(item, withLocation: true)
                            .badge(item.count)
                            .id(item.id)
                    }
                }
            }
        }
    }
}
