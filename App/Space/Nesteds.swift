import SwiftUI
import API
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
        @EnvironmentObject private var app: AppRouter
        
        var items: [UserCollection]
        
        func item(_ collection: UserCollection) -> some View {
            Button {
                app.path.append(collection)
            } label: {
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

