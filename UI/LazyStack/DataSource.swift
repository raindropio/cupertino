import SwiftUI

public struct DataSource<D: RandomAccessCollection, C: View> where D.Element: Identifiable & Transferable {
    @Environment(\.lazyStackLayout) private var layout
    
    let data: D
    let content: (D.Element) -> C
    let reorder: ((D.Element.ID, Int) -> Void)?
    let loadMore: () async -> Void
    
    public init(
        _ data: D,
        content: @escaping (D.Element) -> C,
        reorder: ((D.Element.ID, Int) -> Void)? = nil,
        loadMore: @escaping () async -> Void
    ) {
        self.data = data
        self.content = content
        self.reorder = reorder
        self.loadMore = loadMore
    }
}

extension DataSource: View {
    public var body: some View {
        switch layout {
        case .list:
            ListForEach(data: data, reorder: reorder, content: content)
                .infiniteScroll(data, action: loadMore)
            
        case .grid(let width, let staggered):
            Group {
                if staggered {
                    GridStaggered(data, width) { group in
                        GridForEach(group, content: content)
                    }
                } else {
                    GridColumns(width) {
                        GridForEach(data, content: content)
                    }
                }
            }
                .infiniteScroll(data, action: loadMore)
            
        case nil:
            EmptyView()
        }
    }
}
