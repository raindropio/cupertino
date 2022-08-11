import SwiftUI

struct ListForEach<D: RandomAccessCollection, C: View> where D.Element: Identifiable & Transferable {
    @EnvironmentObject private var model: CollectionViewModel<D.Element.ID>
    
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

extension ListForEach: View {
    func performReorder(_ indexSet: IndexSet, _ to: Int) {
        if let reorder = model.reorder,
           indexSet.count == 1,
           let array = data as? [D.Element],
           let first = indexSet.first {
            reorder(array[first].id, to)
        }
    }
    
    var body: some View {
        ForEach(data) {
            content($0)
                .draggable($0)
        }
            .onMove(perform: performReorder)
    }
}
