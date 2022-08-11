import SwiftUI

public struct DataSource<D: RandomAccessCollection, C: View> where D.Element: Identifiable & Transferable {
    @EnvironmentObject private var model: CollectionViewModel<D.Element.ID>
    @Environment(\.collectionViewLayout) private var layout
    
    let data: D
    let content: (D.Element) -> C
    
    public init(
        _ data: D,
        content: @escaping (D.Element) -> C
    ) {
        self.data = data
        self.content = content
    }
}

extension DataSource: View {
    public var body: some View {
        switch layout {
        case .list:
            ListForEach(data, content: content)
            
        case .grid(let width):
            GridColumns(width) {
                GridForEach(data, content: content)
            }
            
        case nil:
            EmptyView()
        }
    }
}
