import SwiftUI
import API
import UI

public struct RaindropSuggestedTags: View {    
    @Binding var raindrop: Raindrop
    var suggestions: RaindropSuggestions
    
    private var items: [String] {
        return suggestions.tags.filter {
            !raindrop.tags.contains($0)
        }
    }
    
    func row(_ tag: String) -> some View {
        Button(tag) {
            raindrop.tags.append(tag)
        }
    }
    
    public var body: some View {
        if !items.isEmpty {
            StripStack {
                ForEach(items, id: \.self, content: row)
                    #if canImport(UIKit)
                    .padding(.vertical, 14)
                    #endif
            }
                .buttonStyle(.dotted)
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
