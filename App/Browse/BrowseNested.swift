import SwiftUI
import API
import Common

struct BrowseNested: View {
    @EnvironmentObject private var c: CollectionsStore
    var find: FindBy
    
    var body: some View {
        if !find.isSearching {
            Memorized(items: c.state.childrens(of: find.collectionId))
        }
    }
}

extension BrowseNested {
    struct Memorized: View {
        @EnvironmentObject private var app: AppRouter
        
        var items: [UserCollection]
        
        var body: some View {
            if !items.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(items) { item in
                            Button {
                                app.browse(item)
                            } label: {
                                UserCollectionRow(item)
                            }
                        }
                    }
                        .scenePadding(.horizontal)
                }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.primary)
                    .clearSection()
                    .padding(.vertical, 8)
            }
        }
    }
}

