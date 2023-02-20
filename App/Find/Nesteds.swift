import SwiftUI
import API
import UI
import Features

struct Nesteds: View {
    @EnvironmentObject private var c: CollectionsStore
    var find: FindBy
    
    var body: some View {
        Memorized(
            items: find.isSearching ?
                [] :
                c.state.childrens(of: find.collectionId)
        )
    }
}

extension Nesteds {
    struct Memorized: View {
        @Environment(\.editMode) private var editMode
        var items: [UserCollection]
        
        func item(_ collection: UserCollection) -> some View {
            DeepLink(.collection(.open(collection.id))) {
                CollectionLabel(collection)
            }
                .dropConsumer(to: collection)
        }
        
        var body: some View {
            if !items.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(items, content: item)
                    }
                        .tint(.secondary)
                        .buttonStyle(.chip)
                        .scenePadding(.horizontal)
                        .frame(height: 44)
                        .fixedSize()
                }
                    .padding(.vertical, 8)
                    .clearSection()
                    .disabled(editMode?.wrappedValue == .active)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

