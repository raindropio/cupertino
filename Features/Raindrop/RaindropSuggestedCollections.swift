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
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(suggestions, id: \.self, content: row)
                        }
                            .buttonStyle(.dotted)
                            .controlSize(.small)
                            .tint(.secondary)
                            .foregroundColor(.primary)
                            #if canImport(UIKit)
                            .padding(.vertical, 14)
                            #endif
                            .padding(.trailing, 32)
                            .fixedSize()
                    }
                    .mask(LinearGradient(
                        gradient: Gradient(colors: Array(repeating: .black, count: 7) + [.clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                }
            }
                .fixedSize(horizontal: false, vertical: true)
                #if canImport(AppKit)
                .padding(.bottom, 8)
                #endif
                .contentTransition(.opacity)
                .transition(.opacity)
                .animation(.default, value: raindrop.collection)
                .animation(.default, value: !suggestions.isEmpty)
                .task(suggest)
                .clearSection()
        }
    }
}
