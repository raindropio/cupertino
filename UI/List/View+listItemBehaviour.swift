import SwiftUI

public extension View {
    func listItemBehaviour<T: Hashable>(_ tag: T) -> some View {
        modifier(ItemBehaviour(tag: tag))
    }
}

fileprivate struct ItemBehaviour<T: Hashable> {
    @EnvironmentObject private var service: ListBehaviourService<T>
    #if canImport(UIKit)
    @Environment(\.editMode) private var editMode
    #endif
    @Environment(\.defaultMinListRowHeight) private var defaultMinListRowHeight
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
        
        #if canImport(UIKit)
        if editMode?.wrappedValue == .active {
            if service.selection.contains(tag) {
                service.selection.remove(tag)
            } else {
                service.selection.insert(tag)
            }
        } else if let primaryAction = service.primaryAction {
            primaryAction(selection)
        } else {
            service.selection = selection
        }
        #else
        service.selection = selection
        #endif
    }
    
    private func onPressing(_ pressing: Bool) {
        isPressing = pressing
    }
}

extension ItemBehaviour: ViewModifier {
    @ViewBuilder
    private func menuItems() -> some View {
        #if canImport(UIKit)
        if editMode?.wrappedValue != .active {
            service.menu?(Set([tag]))
        }
        #else
        service.menu?(Set([tag]))
        #endif
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
