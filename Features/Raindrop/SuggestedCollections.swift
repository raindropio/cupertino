import SwiftUI
import API
import UI

public struct SuggestedCollections: View {
    @EnvironmentObject private var r: RaindropsStore
    @AppStorage("default-collection") private var defaultCollection: Int?
    
    @Binding var raindrop: Raindrop
    var animation: Namespace.ID
    
    public init(_ raindrop: Binding<Raindrop>, animation: Namespace.ID) {
        self._raindrop = raindrop
        self.animation = animation
    }
    
    private var collections: [UserCollection.ID] {
        var ids = r.state.suggestions(raindrop.link).collections
        if let defaultCollection, !ids.contains(defaultCollection) {
            ids.insert(defaultCollection, at: 1)
        }
        return ids
    }
    
    public var body: some View {
        Group {
            if !collections.isEmpty, raindrop.collection == -1 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(collections, id: \.self) { id in
                            Button {
                                raindrop.collection = id
                            } label: {
                                CollectionLabel(id)
                                    .badge(0)
                            }
                                .matchedGeometryEffect(id: id, in: animation)
                        }
                    }
                        .padding(.leading, 64)
                        .padding(.bottom, 10)
                }
                    .buttonStyle(.chip)
                    .controlSize(.small)
                    .tint(.secondary)
            }
        }
            .contentTransition(.identity)
            .animation(.default, value: raindrop.collection)
            .animation(.default, value: !collections.isEmpty)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden, edges: .top)
            .alignmentGuide(.listRowSeparatorLeading) { _ in 64 }
    }
}
