#if os(macOS)
import SwiftUI
import AppKit

//Props etc
struct CV<Item: Identifiable & Hashable, Header: View, Footer: View, C: View> {
    //props
    var data: [Item]
    @Binding var selection: Set<Item.ID>
    var style: CollectionViewStyle
    var content: (Item) -> C
    var header: () -> Header
    var footer: () -> Footer
    
    //optionals
    var contextAction: ((_ item: Item) -> Void)?
    var reorderAction: ((_ item: Item, _ to: Int) -> Void)?
}

extension CV: NSViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    func makeNSView(context: Context) -> NSScrollView {
        let collectionView = NativeCollectionView(frame: .zero)
        
        //keep scroll position on resize
        collectionView.autoresizingMask = [.width]
        
        //scrollview
        let scrollView = NSScrollView(frame: .zero)
        scrollView.documentView = collectionView
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = true
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
