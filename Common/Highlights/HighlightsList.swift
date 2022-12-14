import SwiftUI
import API

struct HighlightsList: View {
    @Binding var raindrop: Raindrop
    
    var body: some View {
        List {
            if #available(iOS 16, *) {
                ForEach($raindrop.highlights, editActions: .all, content: HighlightEditRow.init)
            } else {
                ForEach($raindrop.highlights, content: HighlightEditRow.init)
            }
        }
    }
}
