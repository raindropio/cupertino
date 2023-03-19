import SwiftUI
import API
import UI

public struct RaindropSuggestedCollections: View {
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var dispatch: Dispatcher
    @AppStorage("last-used-collection") private var lastUsedCollection: Int?
    
    @Binding var raindrop: Raindrop
    
    public init(_ raindrop: Binding<Raindrop>) {
        self._raindrop = raindrop
    }
    
    //load suggestions
    @Sendable private func suggest() async {
        try? await dispatch(RaindropsAction.suggest(raindrop))
    }
    
    private var suggestions: [UserCollection.ID] {
        var ids = r.state.suggestions(raindrop.link).collections
            .filter { $0 != lastUsedCollection }
        if let lastUsedCollection, lastUsedCollection > 0, lastUsedCollection != raindrop.collection {
            ids.insert(lastUsedCollection, at: 0)
        }
        return ids
    }
    
    private func row(_ id: Int) -> some View {
        Button {
            raindrop.collection = id
        } label: {
            CollectionLabel(id)
                .badge(0)
        }
    }
    
    public var body: some View {
        if raindrop.collection == -1 {
            ZStack {
                if !suggestions.isEmpty {
                    StripStack {
                        ForEach(suggestions, id: \.self, content: row)
                            #if canImport(UIKit)
                            .padding(.vertical, 14)
                            #endif
                    }
                        .buttonStyle(.dotted)
                        .controlSize(.small)
                        .tint(.secondary)
                        .foregroundColor(.primary)
                }
            }
                .fixedSize(horizontal: false, vertical: true)
                .contentTransition(.opacity)
                .transition(.opacity)
                .animation(.default, value: raindrop.collection)
                .animation(.default, value: !suggestions.isEmpty)
                .task(suggest)
                .clearSection()
        }
    }
}
