#if os(macOS)
import Cocoa
import SwiftUI

class HostCollectionItem: NSCollectionViewItem {
    static var identifier = NSUserInterfaceItemIdentifier("UI.HostCollectionItem")
    
    var isCard = false
    
    override func loadView() {
        view = NSView()
        view.wantsLayer = true
    }
    
    override func prepareForReuse() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
    }
    
    func host<Content>(_ rootView: Content, isCard: Bool = false) where Content: View {
        self.isCard = isCard
        
        if let item = view.subviews.first as? NSHostingView<Content>{
            item.rootView = rootView
        } else {
            let item = NSHostingView(rootView: rootView)
            view.addSubview(item)
            
            item.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                item.topAnchor.constraint(equalTo: view.topAnchor),
                item.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                item.widthAnchor.constraint(equalTo: view.widthAnchor),
            ])
            view.layer?.masksToBounds = true
        }
        
        updateAppearance()
    }
    
    //appearance
    override var highlightState: NSCollectionViewItem.HighlightState {
        didSet {
            if oldValue != highlightState {
                updateAppearance()
            }
        }
    }

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    func updateAppearance() {
        guard isViewLoaded else { return }
            
        let showAsHighlighted = (highlightState == .forSelection) ||
            (isSelected && highlightState != .forDeselection) ||
            (highlightState == .asDropTarget)
                        
        view.layer?.backgroundColor = showAsHighlighted ?
            ((collectionView?.isFirstResponder ?? false) ? NSColor.selectedContentBackgroundColor.cgColor : NSColor.unemphasizedSelectedContentBackgroundColor.cgColor) :
            (isCard ? NSColor.alternatingContentBackgroundColors.last!.cgColor : nil)
        
        view.layer?.cornerRadius = isCard ? 3 : 0
    }

}
#endif
