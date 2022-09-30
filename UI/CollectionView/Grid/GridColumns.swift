import SwiftUI

struct GridColumns<Content: View> {
    @ScaledMetric private var gap = CollectionViewLayout.gap(.grid(0, false))
    
    let width: CGFloat
    let content: () -> Content
    
    init(_ width: CGFloat, content: @escaping () -> Content) {
        self.width = width
        self.content = content
    }
}

extension GridColumns: View {
    var body: some View {
        let columns: [GridItem] = [
            .init(.adaptive(minimum: width), spacing: gap, alignment: .top)
        ]
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: gap, content: content)
    }
}
