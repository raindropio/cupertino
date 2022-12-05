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
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                ._onButtonGesture(pressing: nil) {
                    model.tap(element.id)
                }
                .contextMenu {
                    model.contextMenu?(Set([element.id]))
                }
        }
    }
}
