import SwiftUI
import API
import UI

public struct RaindropSuggestedCollections: View {
    @Binding var raindrop: Raindrop
    var suggestions: RaindropSuggestions

    func row(_ id: Int) -> some View {
        Button {
            raindrop.collection = id
        } label: {
            CollectionLabel(id)
                .frame(maxWidth: 175)
        }
            .collectionTint(id)
    }
    
    public var body: some View {
        if raindrop.collection < 0, !suggestions.collections.isEmpty {
            StripStack {
                ForEach(suggestions.collections, id: \.self, content: row)
                    #if canImport(UIKit)
                    .padding(.vertical, 14)
                    #endif
            }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .tint(.gray)
                .foregroundColor(.primary)
                .labelStyle(.titleOnly)
                .clearSection()
                .contentTransition(.opacity)
                .transition(.opacity)
        }
    }
}
