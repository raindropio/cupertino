import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func tag<T: Hashable>(_ tag: T) -> some View {
        if #available(iOS 16, *) {
            content.tag(tag)
        } else {
            content
                .modifier(ListTagModifier(tag: tag))
                .tag(tag)
        }
    }
}

extension Backport {
    struct ListTagModifier<T: Hashable>: ViewModifier {
        @Environment(\.editMode) private var editMode
        @Environment(\.backportListSelection) @Binding private var backportListSelection
        @Environment(\.backportListPrimaryAction) private var backportListPrimaryAction
        @State private var pressing = false
        
        var tag: T
        
        var background: Optional<Color> {
            pressing || backportListSelection == (tag as AnyHashable) ? .gray.opacity(0.35) : nil
        }
        
        func onPress() {
            if let backportListPrimaryAction {
                backportListPrimaryAction(tag)
                backportListSelection = nil
            } else {
                backportListSelection = tag
            }
        }
        
        func onPressing(_ pressing: Bool) {
            self.pressing = pressing
        }
        
        func body(content: Content) -> some View {
            content
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                ._onButtonGesture(pressing: onPressing, perform: onPress)
                .allowsHitTesting(editMode?.wrappedValue != .active)
                .listRowBackground(background)
        }
    }
}
