import SwiftUI
import API
import UI

public struct RaindropSuggestedCollections: View {
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var dispatch: Dispatcher
    
    @Binding var raindrop: Raindrop
    
    public init(_ raindrop: Binding<Raindrop>) {
        self._raindrop = raindrop
    }
    
    private var suggestions: [UserCollection.ID] {
        return r.state.suggestions(raindrop.link).collections
    }
    
    public var body: some View {
        Memorized(raindrop: $raindrop, suggestions: suggestions)
    }
}

extension RaindropSuggestedCollections {
    fileprivate struct Memorized: View {
        @Binding var raindrop: Raindrop
        var suggestions: [UserCollection.ID]
        
        func row(_ id: Int) -> some View {
            Button {
                raindrop.collection = id
            } label: {
                CollectionLabel(id)
                    .frame(maxWidth: 175)
            }
                .collectionTint(id)
        }
        
        var body: some View {
            if raindrop.collection < 0 {
                ZStack {
                    if !suggestions.isEmpty {
                        StripStack {
                            ForEach(suggestions, id: \.self, content: row)
                                #if canImport(UIKit)
                                .padding(.vertical, 14)
                                #endif
                        }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .tint(.gray)
                            .foregroundColor(.primary)
                            .labelStyle(.titleOnly)
                    }
                }
                    .fixedSize(horizontal: false, vertical: true)
                    .contentTransition(.opacity)
                    .transition(.opacity)
                    .animation(.default, value: raindrop.collection)
                    .animation(.default, value: !suggestions.isEmpty)
                    .clearSection()
            }
        }
    }
}
