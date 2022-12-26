import SwiftUI
import API
import UI

struct FindCollections: View {
    @EnvironmentObject private var c: CollectionsStore
    var search: String
    
    var body: some View {
        Memorized(
            user: c.state.find(search)
        )
    }
}

extension FindCollections {
    fileprivate struct Memorized: View {
        var user: [UserCollection]
        
        var body: some View {
            if !user.isEmpty {
                Section("Found \(user.count) collections") {
                    ForEach(user) { item in
                        UserCollectionRow(item, withLocation: true)
                            .dropConsumer(to: item)
                            .backport.tag(item.id)
                    }
                }
            }
        }
    }
}
