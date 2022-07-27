import SwiftUI

public struct ItemStackForEach<Item: Identifiable & Hashable, Content: View> {
    public var data: [Item]
    @ViewBuilder public var content: (_ item: Item) -> Content
    
    @Environment(\.itemStackStyle) var style
    
    //optionals
    var onMove: ((IndexSet, Int) -> Void)?
    public func onMove(perform action: ((IndexSet, Int) -> Void)?) -> some View {
        var copy = self; copy.onMove = action; return copy
    }
    
    @MainActor public init(_ data: [Item], @ViewBuilder content: @escaping (_ item: Item) -> Content) {
        self.data = data
        self.content = content
    }
}

extension ItemStackForEach: View {
    public var body: some View {
        switch style {
        case .list:
            RList(data: data, content: content, onMove: onMove)
        case .grid(let width):
            RGrid(width: width, data: data, content: content, onMove: onMove)
        }
    }
}
