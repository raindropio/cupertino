import SwiftUI

public struct CollectionView<Item: Identifiable, Header: View, Footer: View, Content: View>: View where Item: Hashable {
    //props
    public var data: [Item]
    @Binding public var selection: Set<Item.ID>
    public var style: CollectionViewStyle
    public var content: (Item) -> Content
    public var header: () -> Header
    public var footer: () -> Footer
    
    //optionals
    public var contextAction: ((_ item: Item) -> Void)?
    public func contextAction(_ action: ((_ item: Item) -> Void)?) -> Self {
        var copy = self; copy.contextAction = action; return copy
    }
    
    public var reorderAction: ((_ item: Item, _ to: Int) -> Void)?
    public func reorderAction(_ action: ((_ item: Item, _ to: Int) -> Void)?) -> Self {
        var copy = self; copy.reorderAction = action; return copy
    }
        
    public init(
        _ data: [Item],
        selection: Binding<Set<Item.ID>>,
        style: CollectionViewStyle,
        content: @escaping (Item) -> Content,
        header: @escaping () -> Header,
        footer: @escaping () -> Footer
    ) {
        self.data = data
        self._selection = selection
        self.style = style
        self.content = content
        self.header = header
        self.footer = footer
    }
    
    public var body: some View {
        CV(
            data: data,
            selection: $selection,
            style: style,
            content: content,
            header: header,
            footer: footer,
            contextAction: contextAction,
            reorderAction: reorderAction
        )
            //.id(style)
            .ignoresSafeArea(.all)
    }
}
