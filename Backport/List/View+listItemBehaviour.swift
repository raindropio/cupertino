import SwiftUI

public extension View {
    func listItemBehaviour<T: Hashable>(_ tag: T) -> some View {
        modifier(ItemBehaviour(tag: tag))
    }
}

fileprivate struct ItemBehaviour<T: Hashable> {
    @EnvironmentObject private var service: ListBehaviourService<T>
    @Environment(\.editMode) private var editMode
    @State private var isPressing = false

    var tag: T
}

extension ItemBehaviour {
    private var isSelected: Bool {
        service.selection.contains(tag)
    }
    
    private var background: Optional<Color> {
        isPressing || isSelected ? .gray.opacity(0.35) : nil
    }
}

extension ItemBehaviour {
    private func onPress() {
        let selection = Set([tag])
        
        if let primaryAction = service.primaryAction {
            primaryAction(selection)
        } else {
            service.selection = selection
        }
    }
    
    private func onPressing(_ pressing: Bool) {
        isPressing = pressing
    }
}

extension ItemBehaviour: ViewModifier {
    private func menuItems() -> some View {
        service.menu?(Set([tag]))
    }
    
    func body(content: Content) -> some View {
        content
            //frame
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            //tapping
            ._onButtonGesture(pressing: onPressing, perform: onPress)
            .allowsHitTesting(editMode?.wrappedValue != .active)
            //menu
            .contextMenu(menuItems: menuItems)
            //background
            .background(background)
            .listRowBackground(background)
    }
}
