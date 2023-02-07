import SwiftUI
import API

public struct HighlightsList: View {
    @Binding var raindrop: Raindrop
    
    public init(_ raindrop: Binding<Raindrop>) {
        self._raindrop = raindrop
    }
    
    public var body: some View {
        List {
            ForEach($raindrop.highlights, editActions: .delete, content: HighlightEditRow.init)
        }
        .toolbar {
            EditButton()
        }
    }
}
