import SwiftUI
import API

struct HighlightsList: View {
    @Binding var raindrop: Raindrop
    
    var body: some View {
        List {
            ForEach($raindrop.highlights, editActions: .delete, content: HighlightEditRow.init)
        }
        .toolbar {
            EditButton()
        }
    }
}
