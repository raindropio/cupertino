import SwiftUI

struct GridForEach<D: RandomAccessCollection, C: View> where D.Element: Identifiable {
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
                .infiniteScrollElement(element.id)
                .listItemBehaviour(element.id)
                .background(Color.secondaryGroupedBackground)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}
