#if os(iOS)
import SwiftUI
import UIKit

//Props etc
public struct CollectionView<Item: Identifiable, Header: View, Content: View> where Item: Hashable {
    //aliases
    public typealias DataSource = UICollectionViewDiffableDataSource<String, Item>
    public typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, Item>
    public typealias ContentRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item>
    
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
}
#endif
