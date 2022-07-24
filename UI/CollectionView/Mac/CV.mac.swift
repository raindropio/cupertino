#if os(macOS)
import SwiftUI
import AppKit

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

extension CV: NSViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    func makeNSView(context: Context) -> NSScrollView {
        let collectionView = NativeCollectionView()
        
        //scrollview
        let scrollView = NSScrollView()
        scrollView.documentView = collectionView
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = true
        scrollView.contentView.drawsBackground = false
        scrollView.drawsBackground = false
        scrollView.backgroundColor = .clear
        
        //apply to coordinator
        context.coordinator.start(collectionView)
        
        return scrollView
    }
    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        context.coordinator.update(self, environment: context.environment)
    }
    static func dismantleNSView(_ scrollView: NSScrollView, coordinator: Coordinator) {
        coordinator.cleanup()
    }
}
#endif
