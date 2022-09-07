import SwiftUI

struct GridColumns<Content: View> {
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
            .init(.adaptive(minimum: width), spacing: 12)
        ]
        
        LazyVGrid(columns: columns, spacing: 12, content: content)
            .padding(.horizontal, 16)
    }
}
