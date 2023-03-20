import SwiftUI

public extension View {
    func listItemBehaviour<T: Hashable>(_ tag: T) -> some View {
        modifier(ItemBehaviour(tag: tag))
    }
}

fileprivate struct ItemBehaviour<T: Hashable> {
    @EnvironmentObject private var service: ListBehaviourService<T>
    @IsEditing private var isEditing
    @Environment(\.colorScheme) private var colorScheme
    @State private var isPressing = false

    var tag: T
}

extension ItemBehaviour {
    private var isSelected: Bool {
        service.selection.contains(tag)
    }
    
    private var isHighlighted: Bool {
        isPressing || isSelected
    }
    
    private var background: AnyShapeStyle {
        isHighlighted ? AnyShapeStyle(.selection) : AnyShapeStyle(Color.clear)
    }
    
    private var foreground: Optional<Color> {
        isHighlighted ? .white : nil
    }
}

extension ItemBehaviour {
    private func onPress() {
        let selection = Set([tag])
        
        if isEditing {
            if service.selection.contains(tag) {
                service.selection.remove(tag)
            } else {
                service.selection.insert(tag)
            }
            return
        }
        
        #if canImport(UIKit)
        if let primaryAction = service.primaryAction {
            primaryAction(selection)
            return
        }
        #endif
        
        service.selection = selection
    }
    
    private func onPressing(_ pressing: Bool) {
        isPressing = pressing
    }
}

extension ItemBehaviour: ViewModifier {
    @ViewBuilder
    private func menuItems() -> some View {
        if !isEditing {
            service.menu?(Set([tag]))
        }
    }
    
    func body(content: Content) -> some View {
        content
            //frame
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            //tapping
            ._onButtonGesture(pressing: onPressing, perform: onPress)
            //menu
            .contextMenu(menuItems: menuItems)
            //background
            .opacity(isSelected ? 0.8 : 1)
            .background(background)
            .foregroundColor(foreground)
//            .environment(\.colorScheme, isHighlighted ? .dark : colorScheme)
    }
}
