#if os(iOS)
import SwiftUI
import UIKit

//Props etc
struct CV<Item: Identifiable, Header: View, Content: View> where Item: Hashable {
    //aliases
    typealias DataSource = UICollectionViewDiffableDataSource<String, Item>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, Item>
    typealias ContentRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item>
    
    //props
    var data: [Item]
    @Binding var selection: Set<Item.ID>
    var style: CollectionViewStyle
    var header: () -> Header
    var content: (Item) -> Content
    
    //optionals
    var contextAction: ((_ item: Item) -> Void)?
    func contextAction(_ action: ((_ item: Item) -> Void)?) -> Self {
        var copy = self; copy.contextAction = action; return copy
    }
}

extension CV: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    func makeUIView(context: Context) -> UICollectionView { context.coordinator.collectionView }
    func updateUIView(_ uiView: UICollectionView, context: Context) { context.coordinator.update(self, environment: context.environment) }
}
#endif
