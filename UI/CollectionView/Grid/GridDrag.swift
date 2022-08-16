import SwiftUI

struct GridDrag<Element: Identifiable & Transferable> {
    @EnvironmentObject private var model: CollectionViewModel<Element.ID>
    var element: Element
    var getIndex: (_ element: Element) -> Int?
}

extension GridDrag: ViewModifier {
    func body(content: Content) -> some View {
        content
            .draggable(element)
            .dropDestination(for: Element.self) { dragging, _ in
                if dragging.count == 1,
                   let origin = dragging.first,
                   let from = getIndex(origin),
                   let to = getIndex(element),
                    from != to {
                    model.reorder?(origin.id, to > from ? to + 1 : to)
                    return true
                }
                return true
            }
    }
}
