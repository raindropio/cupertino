import SwiftUI

extension ItemStackForEach {
    struct RGrid: View {
        let data: [Item]
        @ViewBuilder let content: (_ item: Item) -> Content
        let onMove: ((IndexSet, Int) -> Void)?
        
        private let columns: [GridItem]
        @ScaledMetric private var padding = ItemStackConstants.padding
        @ScaledMetric private var gap = ItemStackConstants.gap
                
        init(
            width: CGFloat,
            data: [Item],
            @ViewBuilder content: @escaping (_: Item) -> Content,
            onMove: ((IndexSet, Int) -> Void)? = nil
        ) {
            self.data = data
            self.content = content
            self.columns = [
                GridItem(.flexible()),
                GridItem(.flexible()),
            ]
            self.onMove = onMove
        }
        
        var body: some View {
            LazyVGrid(
                columns: columns,
                alignment: .leading,
                spacing: gap
            ) {
                FakeListForEach(data, content: content)
                    .onMove(perform: onMove)
                    .cornerRadius(5)
            }
                .padding(padding)
                .labelStyle(RGridLabelStyle())
        }
    }
}
