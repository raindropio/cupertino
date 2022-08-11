import SwiftUI

struct GridColumns<Content: View> {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let columns: [GridItem]
    let content: () -> Content
    
    init(_ width: CGFloat, content: @escaping () -> Content) {
        self.columns = [.init(.adaptive(minimum: width))]
        self.content = content
    }
}

extension GridColumns: View {
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12, content: content)
            .padding(horizontalSizeClass == .compact ? 16 : 24)
    }
}
