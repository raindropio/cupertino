import SwiftUI

struct GridCard<Element: Identifiable> {
    @EnvironmentObject private var model: LazyStackModel<Element.ID>
    #if canImport(UIKit)
    @Environment(\.editMode) private var editMode
    #endif
    
    var element: Element
}

extension GridCard: ViewModifier {
    func body(content: Content) -> some View {
        let isSelected = model.isSelected(element.id)
        
        #if canImport(UIKit)
        let isEditing = editMode?.wrappedValue == .active
        #else
        let isEditing = false
        #endif

        content
            .background(
                isSelected ? Color.tertiaryLabel : Color.secondaryGroupedBackground
            )
            .opacity(isSelected ? 0.9 : (isEditing ? 0.6 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .contentShape(RoundedRectangle(cornerRadius: 5))
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
