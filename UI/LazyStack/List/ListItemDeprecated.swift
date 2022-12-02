import SwiftUI

@available(iOS, deprecated: 16)
struct ListItemDeprecated<Element: Identifiable> {
    @EnvironmentObject private var model: LazyStackModel<Element.ID>
    var element: Element
}

extension ListItemDeprecated: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            content
        } else {
            content
                ._onButtonGesture {
                    model.touch(element.id, down: $0)
                } perform: {
                    model.tap(element.id)
                }
                .contextMenu {
                    model.contextMenu?(Set([element.id]))
                }
        }
    }
}
