import SwiftUI

public struct ItemStack<S: Hashable, C: View> {
    @Binding public var selection: Set<S>
    public var style: ItemStackStyle = .list
    @ViewBuilder public var content: () -> C
        
    @MainActor public init(selection: Binding<Set<S>>, @ViewBuilder content: @escaping () -> C) {
        self._selection = selection
        self.content = content
    }
    
    //optionals
    public func itemStackStyle(_ style: ItemStackStyle) -> Self {
        var copy = self; copy.style = style; return copy
    }
}

extension ItemStack: View {
    public var body: some View {
        Group {
            switch style {
            case .list:
                ISList(selection: $selection, content: content)
            case .grid(_):
                ISGrid(selection: $selection, content: content)
            }
        }
            .environment(\.itemStackStyle, style)
    }
}
