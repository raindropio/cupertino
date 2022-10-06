import SwiftUI

struct GridColumns<Content: View> {
    @Environment(\.gridScrollColumns) private var columns
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
        let columns = [GridItem](
            repeating: .init(
                .flexible(),
                spacing: gap / 2,
                alignment: .top
            ),
            count: columns
        )
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: gap / 2, content: content)
    }
}
