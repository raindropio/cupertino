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
                c.state.childrens(of: find.collectionId),
            animation: c.state.animation
        )
    }
}

extension Nesteds {
    struct Memorized: View {
        @IsEditing private var isEditing
        var items: [UserCollection]
        var animation: UUID
        
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
                        .fixedSize()
                }
                    .padding(.vertical, 8)
                    .clearSection()
                    .disabled(isEditing)
                    .fixedSize(horizontal: false, vertical: true)
                    .animation(.default, value: animation)
            }
        }
    }
}

