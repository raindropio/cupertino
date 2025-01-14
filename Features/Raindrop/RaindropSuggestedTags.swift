import SwiftUI
import API
import UI

public struct RaindropSuggestedTags: View {    
    @Binding var raindrop: Raindrop
    var suggestions: RaindropSuggestions
    
    private var existing: [String] {
        return suggestions.tags.filter {
            !raindrop.tags.contains($0)
        }
    }
    
    private var new: [String] {
        return suggestions.new_tags.filter {
            !raindrop.tags.contains($0)
        }
    }
    
    func row(_ tag: String, isNew: Bool = false) -> some View {
        Button {
            raindrop.tags.append(tag)
        } label: {
            if isNew {
                Label(tag, systemImage: "plus")
            } else {
                Text(tag)
            }
        }
    }
    
    public var body: some View {
        if (!existing.isEmpty || !new.isEmpty) {
            StripStack {
                Group {
                    ForEach(existing, id: \.self) { row($0) }
                    ForEach(new, id: \.self) { row($0, isNew: true) }
                }
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
