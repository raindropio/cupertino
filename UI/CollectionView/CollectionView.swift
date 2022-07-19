#if os(iOS)
import SwiftUI
import UIKit

//Props etc
public struct CollectionView<Item: Identifiable, Header: View, Content: View>: View where Item: Hashable {
    //props
    public var data: [Item]
    @Binding public var selection: Set<Item.ID>
    public var style: CollectionViewStyle
    public var header: () -> Header
    public var content: (Item) -> Content
    
    //optionals
    public var contextAction: ((_ item: Item) -> Void)?
    public func contextAction(_ action: ((_ item: Item) -> Void)?) -> Self {
        var copy = self; copy.contextAction = action; return copy
    }
    
    //internal
    @Environment(\.editMode) private var editMode
    
    public init(
        _ data: [Item],
        selection: Binding<Set<Item.ID>>,
        style: CollectionViewStyle = .list,
        header: @escaping () -> Header,
        content: @escaping (Item) -> Content
    ) {
        self.data = data
        self._selection = selection
        self.style = style
        self.header = header
        self.content = content
    }
    
    public var body: some View {
        CV(
            data: data,
            selection: $selection,
            style: style,
            header: header,
            content: content,
            contextAction: contextAction
        )
            .ignoresSafeArea(.all)
    }
}
#endif
