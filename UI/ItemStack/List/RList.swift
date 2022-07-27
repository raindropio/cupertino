import SwiftUI

extension ItemStackForEach {
    struct RList: View {
        var data: [Item]
        @ViewBuilder var content: (_ item: Item) -> Content
        let onMove: ((IndexSet, Int) -> Void)?

        var body: some View {
            ForEach(data) {
                content($0)
                    .tag($0.id)
            }
                .onMove(perform: onMove)
        }
    }
}
