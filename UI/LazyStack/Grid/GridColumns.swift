import SwiftUI

struct GridColumns<Content: View> {
    @Environment(\.gridScrollColumns) private var columns
    @ScaledMetric private var gap = LazyStackLayout.gap(.grid(0, false))
    
    let width: Double
    let content: () -> Content
    
    init(_ width: Double, content: @escaping () -> Content) {
        self.width = width
        self.content = content
    }
}

extension GridColumns: View {
    var body: some View {
        let gridColumns = [GridItem](
            repeating: .init(
                .flexible(),
                spacing: gap / 2,
                alignment: .top
            ),
            count: columns
        )
        
        LazyVGrid(columns: gridColumns, alignment: .leading, spacing: gap / 2, content: content)
            .scenePadding(.horizontal)
            .padding(.vertical, gap / 3)
            .animation(.default, value: columns)
    }
}
