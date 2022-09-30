import SwiftUI

struct GridCard<Element: Identifiable & Transferable> {
    @EnvironmentObject private var model: CollectionViewModel<Element.ID>
    @Environment(\.editMode) private var editMode
    
    var element: Element
}

extension GridCard: ViewModifier {
    func body(content: Content) -> some View {
        let isSelected = model.isSelected(element.id)
        let isEditing = editMode?.wrappedValue.isEditing ?? false

        content
            .background(
                isSelected ?
                    Color(UIColor.tertiaryLabel) :
                    Color(UIColor.secondarySystemGroupedBackground)
            )
            .opacity(!isSelected && isEditing ? 0.6 : 1)
            .cornerRadius(5)
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
