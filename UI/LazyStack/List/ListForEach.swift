import SwiftUI
import UniformTypeIdentifiers

struct ListForEach<D: RandomAccessCollection, C: View> where D.Element: Identifiable {
    let data: D
    let reorder: ((D.Element.ID, Int) -> Void)?
    let insert: ((Int, [NSItemProvider]) -> Void)?
    let insertOf: [UTType]
    let content: (D.Element) -> C
}

extension ListForEach: View {
    func performReorder(_ indexSet: IndexSet, _ to: Int) {
        if let reorder = reorder,
           indexSet.count == 1,
           let array = data as? [D.Element],
           let first = indexSet.first,
            first != to {
            reorder(
                array[first].id,
                first < to ? to - 1 : to
            )
        }
    }
    
    var body: some View {
        ForEach(data) {
            content($0)
                .infiniteScrollElement($0.id)
                .backport.tag($0.id)
        }
            .onMove(perform: performReorder)
            .onInsert(of: insertOf, perform: insert ?? { _,_ in })
            .moveDisabled(reorder == nil)
    }
}
