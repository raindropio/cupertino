import SwiftUI
import API
import UI

public struct RaindropSuggestedTags: View {
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var dispatch: Dispatcher
    
    @Binding var raindrop: Raindrop
    
    public init(_ raindrop: Binding<Raindrop>) {
        self._raindrop = raindrop
    }
    
    private var suggestions: [String] {
        return r.state.suggestions(raindrop.link).tags.filter {
            !raindrop.tags.contains($0)
        }
    }
    
    public var body: some View {
        Memorized(raindrop: $raindrop, suggestions: suggestions)
    }
}

extension RaindropSuggestedTags {
    fileprivate struct Memorized: View {
        @Binding var raindrop: Raindrop
        var suggestions: [String]
        
        func row(_ tag: String) -> some View {
            Button(tag) {
                raindrop.tags.append(tag)
            }
        }
        
        var body: some View {
            if !suggestions.isEmpty {
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
                        .tint(.gray)
                        .foregroundColor(.primary)
                        .labelStyle(.titleOnly)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .clearSection()
            }
        }
    }
}
