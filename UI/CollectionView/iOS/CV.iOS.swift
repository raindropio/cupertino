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

extension CV: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    func makeUIViewController(context: Context) -> UICollectionViewController { context.coordinator.controller }
    func updateUIViewController(_ uiViewController: UICollectionViewController, context: Context) { context.coordinator.update(self, environment: context.environment) }
}
#endif
