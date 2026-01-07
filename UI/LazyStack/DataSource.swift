import SwiftUI
import UniformTypeIdentifiers

public struct DataSource<D: RandomAccessCollection & Hashable, C: View> where D.Element: Identifiable {
    @Environment(\.lazyStackLayout) private var layout
    
    let data: D
    let content: (D.Element) -> C
    let reorder: ((D.Element.ID, Int) -> Void)?
    let insert: ((Int, [NSItemProvider]) -> Void)?
    let insertOf: [UTType]
    let loadMore: () -> Void

    public init(
        _ data: D,
        content: @escaping (D.Element) -> C,
        reorder: ((D.Element.ID, Int) -> Void)? = nil,
        insert: ((Int, [NSItemProvider]) -> Void)? = nil,
        insertOf: [UTType] = [],
        loadMore: @escaping () -> Void
    ) {
        self.data = data
        self.content = content
        self.reorder = reorder
        self.insert = insert
        self.insertOf = insertOf
        self.loadMore = loadMore
    }
}

extension DataSource: View {
    public var body: some View {
        switch layout {
        case .list:
            ListForEach(data: data, reorder: reorder, insert: insert, insertOf: insertOf, content: content)
                .infiniteScroll(data, action: loadMore)
            
        case .grid(let width, let staggered):
            Group {
                if staggered {
                    GridStaggered(data, width) { group in
                        GridForEach(data: group, content: content)
                    }
                } else {
                    GridColumns(width) {
                        GridForEach(data: data, content: content)
                    }
                }
            }
                .infiniteScroll(data, action: loadMore)
                .contentShape(Rectangle())
                .onDrop(of: insertOf, isTargeted: .constant(insert != nil)) {
                    if let insert {
                        insert(0, $0)
                        return true
                    }
                    return false
                }
            
        case nil:
            EmptyView()
        }
    }
}
