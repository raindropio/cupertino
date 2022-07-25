#if os(macOS)
import Cocoa
import SwiftUI

class HostCollectionItem: NSCollectionViewItem {
    static var identifier = NSUserInterfaceItemIdentifier("UI.CollectionViewItem")
    
    //props
    var content: AnyView? = nil {
        didSet { rerender() }
    }
    
    var isCard = false {
        didSet { rerender() }
    }
    
    override var highlightState: NSCollectionViewItem.HighlightState {
        didSet { rerender() }
    }

    override var isSelected: Bool {
        didSet { rerender() }
    }
    
    //view
    override func loadView() {
        view = NSHostingView(rootView: makeView())
        view.wantsLayer = true
    }
    
    func rerender() {
        (view as? NSHostingView)?.rootView = makeView()
    }
    
    @ViewBuilder
    func makeView() -> some View {
        let highlighted = (highlightState == .forSelection) || (isSelected && highlightState != .forDeselection) || (highlightState == .asDropTarget)
        
        VStack {
            content
        }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .background(highlighted ?
                ((collectionView?.isFirstResponder ?? false) ? Color.accentColor : Color.secondary.opacity(0.5)) :
                isCard ? .secondary.opacity(0.1) : .clear
            )
            .cornerRadius(isCard ? 3 : 0)
    }
}
#endif
