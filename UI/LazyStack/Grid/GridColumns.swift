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
    private var gridItems: [GridItem] {
        .init(
            repeating: .init(
                .flexible(),
                spacing: gap / 2,
                alignment: .top
            ),
            count: columns
        )
    }
    
    var body: some View {
        Memorized(gridItems: gridItems, spacing: gap / 2, content: content)
    }
}

extension GridColumns {
    fileprivate struct Memorized: View {
        var gridItems: [GridItem]
        var spacing: Double
        var content: () -> Content
        
        var body: some View {
            LazyVGrid(columns: gridItems, alignment: .leading, spacing: spacing, content: content)
                #if canImport(UIKit)
                .safeAnimation(.default, value: gridItems.count)
                #endif
        }
    }
}
