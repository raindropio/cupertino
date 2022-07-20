#if os(iOS)
import SwiftUI
import UIKit

//Props etc
struct CV<Item: Identifiable & Hashable, Header: View, Content: View> {
    //props
    var data: [Item]
    @Binding var selection: Set<Item.ID>
    var style: CollectionViewStyle
    var header: () -> Header
    var content: (Item) -> Content
    
    //optionals
    var contextAction: ((_ item: Item) -> Void)?
    var reorderAction: ((_ item: Item, _ to: Int) -> Void)?
}

extension CV: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    func makeUIView(context: Context) -> UICollectionView { context.coordinator.collectionView }
    func updateUIView(_ uiView: UICollectionView, context: Context) { context.coordinator.update(self, environment: context.environment) }
}
#endif
