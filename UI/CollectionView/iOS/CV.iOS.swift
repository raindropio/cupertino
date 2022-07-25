#if os(iOS)
import SwiftUI
import UIKit

//Props etc
struct CV<Item: Identifiable & Hashable, Header: View, Footer: View, Content: View> {
    //props
    var data: [Item]
    @Binding var selection: Set<Item.ID>
    var style: CollectionViewStyle
    var content: (Item) -> Content
    var header: () -> Header
    var footer: () -> Footer
    
    //optionals
    var contextAction: ((_ item: Item) -> Void)?
    var reorderAction: ((_ item: Item, _ to: Int) -> Void)?
}

extension CV: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    func makeUIView(context: Context) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CVLayout(style))
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        context.coordinator.start(collectionView)
        return collectionView
    }
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        context.coordinator.update(self, environment: context.environment)
    }
    static func dismantleUIView(_ uiView: UICollectionView, coordinator: Coordinator) {
        coordinator.cleanup()
    }
}
#endif
