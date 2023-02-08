import SwiftUI
import API

public struct RaindropHighlights: View {
    @Binding var raindrop: Raindrop
    
    public init(_ raindrop: Binding<Raindrop>) {
        self._raindrop = raindrop
    }
    
    public var body: some View {
        List {
            ForEach($raindrop.highlights, content: HighlightEditRow.init)
        }
            .navigationTitle(Filter.Kind.highlights.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}
