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
    
    func host<Content>(_ rootView: Content, isCard: Bool = false) where Content: View {
        self.isCard = isCard
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }

        let hostView = NSHostingView(rootView: rootView)
        self.view.addSubview(hostView)
        hostView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            hostView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            hostView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            hostView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        hostView.layer?.masksToBounds = true
        
        updateAppearance()
    }
    
    //appearance
    override var highlightState: NSCollectionViewItem.HighlightState {
        didSet {
            updateAppearance()
        }
    }

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    private func updateAppearance() {
        guard isViewLoaded else { return }
        
        let showAsHighlighted = (highlightState == .forSelection) ||
            (isSelected && highlightState != .forDeselection) ||
            (highlightState == .asDropTarget)
        
        view.layer?.backgroundColor = showAsHighlighted ?
            NSColor.selectedContentBackgroundColor.cgColor :
        (isCard ? NSColor.alternatingContentBackgroundColors.last!.cgColor : nil)
        view.layer?.cornerRadius = isCard ? 3 : 0
    }

}
#endif
