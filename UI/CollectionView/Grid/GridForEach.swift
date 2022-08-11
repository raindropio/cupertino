import SwiftUI

struct GridForEach<D: RandomAccessCollection, C: View> where D.Element: Identifiable & Transferable {
    let data: D
    let content: (D.Element) -> C
    
    init(
        _ data: D,
        content: @escaping (D.Element) -> C
    ) {
        self.data = data
        self.content = content
    }
}

extension GridForEach: View {
    func getIndex(_ element: D.Element) -> Int? {
        if let items = data as? [D.Element] {
            return items.firstIndex { $0.id == element.id }
        }
        return nil
    }
    
    var body: some View {
        ForEach(data) { element in
            content(element)
                .modifier(GridCard(element: element))
                .modifier(GridDrag(element: element, getIndex: getIndex))
        }
    }
}
