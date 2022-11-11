import SwiftUI
import API

struct CollectionsCarousel: View {
    @EnvironmentObject private var app: AppRouter
    
    var items: [UserCollection]
    
    var body: some View {
        if !items.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(items) { item in
                        Button {
                            app.push(.browse(.init(item)))
                        } label: {
                            UserCollectionItem(collection: item)
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

