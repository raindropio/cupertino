import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func tag<T: Hashable>(_ tag: T) -> some View {
        if #available(iOS 16, *) {
            content.tag(tag)
        } else {
            content
                .modifier(ListSelectionModifier(tag: tag))
                .tag(tag)
        }
    }
}

extension Backport {
    struct ListSelectionModifier<T: Hashable>: ViewModifier {
        @Environment(\.backportListSelection) @Binding private var backportListSelection
        var tag: T
        
        var background: Optional<Color> {
            backportListSelection == (tag as AnyHashable) ? .gray.opacity(0.5) : nil
        }
        
        func body(content: Content) -> some View {
            content
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                ._onButtonGesture(pressing: nil) {
                    backportListSelection = tag
                }
                .listRowBackground(background)
        }
    }
}
